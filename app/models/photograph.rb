class Photograph < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_one :metadata

  cache_has_one :metadata, embed: true

  image_accessor :image

  validates :user_id, :image, presence: true

  def exif
    MiniExiftool.new(image.file.path)
  end
end
