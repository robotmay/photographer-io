class PhotoExpansionWorker
  class MetadataRecordMissing < StandardError; end

  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :photos

  def perform(photograph_id)
    begin
      timeout(300) do
        @photo = Photograph.find(photograph_id)

        # Extract the metadata and save it
        extract_metadata

        # Generate all the other image sizes
        generate_images

        @photo.save!
      end
    rescue Exception => ex
      if @photo.present?
        @photo.logs << [ex.message, "\n", ex.backtrace.take(5).join("\n")]
      end

      raise ex
    end
  end

  private

  def extract_metadata
    @photo.logs << "Extracting metadata"

    Benchmark.measure "Extracting metadata" do
      metadata = @photo.metadata

      # It's possible that Sidekiq could hit this before Postgres catches up
      if metadata.nil?
        @photo.logs << "Metadata record missing"
        raise MetadataRecordMissing
      end

      # Extract the metadata first to allow us to work off that data
      @photo.logs << "Extracting from image file"
      metadata.extract_from_photograph

      @photo.logs << "Saving metadata record"
      if metadata.save!
        @photo.logs << "Metadata record saved"
      else
        @photo.logs << "Metadata didn't save successfully"
      end
    end
  end

  def generate_standard_image
    @photo.logs << "Generating standard image size"

    Benchmark.measure "Generating standard image" do
      # Create a standard image for generating the smaller sizes
      standard_image = @photo.image.thumb("3000x3000>")

      # Set the standard image and save
      @photo.standard_image = standard_image

      @photo.logs << "Saving photo record with standard image size"
      @photo.save!
    end
  end

  def generate_images
    @photo.logs << "Generating image sizes"

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
    ImageWorker.perform_async(@photo.id, :standard_image, :small_thumbnail_image, "100x100#", "-quality 70")
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
