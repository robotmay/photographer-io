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
        photo.homepage_image = photo.standard_image.thumb("2000x").encode(:jpg, "-quality 80")
        photo.large_image = photo.standard_image.thumb("1500x").encode(:jpg, "-quality 80")
      elsif photo.standard_image.height > photo.standard_image.width
        photo.homepage_image = photo.standard_image.thumb("2000x1400#").encode(:jpg, "-quality 80")
        photo.large_image = photo.standard_image.thumb("x1000").encode(:jpg, "-quality 80")
      else
        photo.homepage_image = photo.standard_image.thumb("2000x1400#").encode(:jpg, "-quality 80")
        photo.large_image = photo.standard_image.thumb("1500x1500>").encode(:jpg, "-quality 80")
      end

      photo.thumbnail_image = photo.standard_image.thumb("500x500>").encode(:jpg, "-quality 70")

      if photo.standard_image.present? && photo.homepage_image.present? && photo.large_image.present? && photo.thumbnail_image.present?
        photo.processing = false
        photo.save!
        photo.trigger_image_processed_push
      else
        raise "Missing image sizes"
      end
    end
  end
end
