class PhotoExpansionWorker
  include Sidekiq::Worker

  def perform(photograph_id)
    photo = Photograph.find(photograph_id)
    photo.standard_image = photo.image.thumb("3000x3000>")
    photo.save

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
    photo.save
  end
end
