class PhotoExpansionWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :photos

  def perform(photograph_id)
    timeout(120) do
      photo = Photograph.find(photograph_id)
      photo.standard_image = photo.image.thumb("3000x3000>")
      photo.save!

      if photo.standard_image.width > photo.standard_image.height
        ImageWorker.perform_async(photo.id, :standard_image, :homepage_image, "2000x", "-quality 80")
        ImageWorker.perform_async(photo.id, :standard_image, :large_image, "1500x", "-quality 80")
      elsif photo.standard_image.height > photo.standard_image.width
        ImageWorker.perform_async(photo.id, :standard_image, :homepage_image, "2000x1400#", "-quality 80")
        ImageWorker.perform_async(photo.id, :standard_image, :large_image, "x1000", "-quality 80")
      else
        ImageWorker.perform_async(photo.id, :standard_image, :homepage_image, "2000x1400#", "-quality 80")
        ImageWorker.perform_async(photo.id, :standard_image, :large_image, "1500x1500>", "-quality 80")
      end

      ImageWorker.perform_async(photo.id, :standard_image, :thumbnail_image, "500x500>", "-quality 70")
    end
  end
end
