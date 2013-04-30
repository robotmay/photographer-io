class Photograph < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
