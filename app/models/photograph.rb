class Photograph < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_one :metadata
  has_many :collection_photographs
  has_many :collections, through: :collection_photographs

  cache_belongs_to :user
  cache_has_one :metadata, embed: true
  cache_has_many :collections, inverse_name: :photographs

  image_accessor :image do
    #
  end

  accepts_nested_attributes_for :metadata
  accepts_nested_attributes_for :collections

  validates :user_id, :image, presence: true
  validates_property :format, of: :image, in: [:jpeg, :jpg], case_sensitive: false

  def exif
    MiniExiftool.new(image.file.path)
  end

  before_create :extract_metadata
  def extract_metadata
    self.metadata = Metadata.new(photograph: self) if metadata.nil?
    metadata.extract_from_photograph
  end

  after_create :save_metadata
  def save_metadata
    metadata.save
  end
end
