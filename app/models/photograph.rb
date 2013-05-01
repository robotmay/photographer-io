class Photograph < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_one :metadata

  cache_has_one :metadata, embed: true

  image_accessor :image do
    #
  end

  validates :user_id, :image, presence: true

  def exif
    MiniExiftool.new(image.file.path)
  end

  before_create :extract_metadata
  def extract_metadata
    self.metadata = Metadata.new(photograph: self) if metadata.nil?
    metadata.extract_from_photograph
  end
end
