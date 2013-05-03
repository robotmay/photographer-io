class Photograph < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :license
  has_one :metadata, dependent: :destroy
  has_many :collection_photographs, dependent: :destroy
  has_many :collections, through: :collection_photographs

  cache_belongs_to :user
  cache_belongs_to :license
  cache_has_one :metadata, embed: true
  cache_has_many :collections, inverse_name: :photographs

  image_accessor :image do
    #
  end

  accepts_nested_attributes_for :metadata
  accepts_nested_attributes_for :collections

  validates :user_id, :image, presence: true
  validates_property :format, of: :image, in: [:jpeg, :jpg], case_sensitive: false

  scope :public, joins(:collections).where(collections: { public: true })
  scope :private, joins(:collections).where(collections: { public: false })
  scope :in_collections, joins(:collections)
  scope :not_in, lambda { |id_array|
    where(Photograph.arel_table[:id].not_in id_array)
  }
  scope :safe_for_work, where(safe_for_work: true)
  scope :not_safe_for_work, where(safe_for_work: false)
  scope :with_license, lambda { |license|
    where(license_id: license.id)
  }

  def public?
    collections.where(public: true).count > 0
  end

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
