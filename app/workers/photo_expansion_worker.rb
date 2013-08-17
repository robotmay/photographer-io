class PhotoExpansionWorker
  class MetadataRecordMissing < StandardError; end

  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :photos

  def perform(photograph_id)
    timeout(300) do
      @photo = Photograph.find(photograph_id)

      # Extract the metadata and save it
      extract_metadata

      # Generate all the other image sizes
      generate_images

      @photo.save!
    end
  end

  private

  def extract_metadata
    Benchmark.measure "Extracting metadata" do
      metadata = @photo.metadata

      # It's possible that Sidekiq could hit this before Postgres catches up
      raise MetadataRecordMissing if metadata.nil?

      # Extract the metadata first to allow us to work off that data
      metadata.extract_from_photograph
      metadata.save!
    end
  end

  def generate_standard_image
    Benchmark.measure "Generating standard image" do
      # Create a standard image for generating the smaller sizes
      standard_image = @photo.image.thumb("3000x3000>")

      # Rotate the image if the metadata says so
      if @photo.metadata.rotate?
        standard_image = standard_image.process(:rotate, @photo.metadata.rotate_by)
      end

      # Set the standard image and save
      @photo.standard_image = standard_image
      @photo.save!
    end
  end

  def generate_images
    # Generate a sensible base size first
    generate_standard_image

    # Generate other sizes based on dimensions
    case
    when @photo.landscape?
      ImageWorker.perform_async(@photo.id, :standard_image, :homepage_image, "2000x", "-quality 80")
      ImageWorker.perform_async(@photo.id, :standard_image, :large_image, "1500x", "-quality 80")
    when @photo.portrait? 
      ImageWorker.perform_async(@photo.id, :standard_image, :homepage_image, "2000x1400#", "-quality 80")
      ImageWorker.perform_async(@photo.id, :standard_image, :large_image, "x1000", "-quality 80")
    else
      ImageWorker.perform_async(@photo.id, :standard_image, :homepage_image, "2000x1400#", "-quality 80")
      ImageWorker.perform_async(@photo.id, :standard_image, :large_image, "1500x1500>", "-quality 80")
    end

    ImageWorker.perform_async(@photo.id, :standard_image, :thumbnail_image, "500x500>", "-quality 70")
  end

  def generate_image(source, target, size, encode_opts)
    Benchmark.measure "Generating #{target} image from #{source}" do
      source = @photo.send(source)
      if source.present?
        image = source.thumb(size).encode(:jpg, encode_opts)
        @photo.send("#{target}=", image)
      else
        raise "Source doesn't exist yet"
      end
    end
  end
end
