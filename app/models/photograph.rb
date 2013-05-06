class Photograph < ActiveRecord::Base
  include IdentityCache
  include Redis::Objects

  belongs_to :user
  belongs_to :license
  has_one :metadata, dependent: :delete
  has_many :collection_photographs, dependent: :destroy
  has_many :collections, through: :collection_photographs
  has_many :recommendations

  cache_belongs_to :user
  cache_belongs_to :license
  cache_has_one :metadata, embed: true
  cache_has_many :collections, inverse_name: :photographs
  cache_has_many :recommendations

  paginates_per 36
  image_accessor :image

  accepts_nested_attributes_for :metadata
  accepts_nested_attributes_for :collections

  validates :user_id, :image, presence: true
  validates_property :format, of: :image, in: [:jpeg, :jpg], case_sensitive: false

  scope :public, -> {
    joins(:collections).where(collections: { public: true })
  }
  scope :private, -> {
    joins(:collections).where(collections: { public: false })
  }
  scope :in_collections, -> { 
    joins(:collections)
  }
  scope :not_in, -> (id_array) {
    where(Photograph.arel_table[:id].not_in id_array)
  }
  scope :safe_for_work, -> {
    where(safe_for_work: true)
  }
  scope :not_safe_for_work, -> {
    where(safe_for_work: false)
  }
  scope :with_license, -> (license) {
    where(license_id: license.id)
  }
  #FIXME
  scope :landscape, -> { 
    joins(:metadata) & Metadata.format('landscape')
  }

  def public?
    collections.where(public: true).count > 0
  end

  def exif
    MiniExiftool.new(image.file.path)
  end

  before_create :set_defaults_from_user_settings
  def set_defaults_from_user_settings
    self.license_id = user.default_license_id
    self.show_location_data = user.show_location_data
    return
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

  def score
    Photograph.rankings[id]
  end

  def increment_score(by = 1)
    Photograph.rankings.increment(id, by)
  end

  def decrement_score(by = 1)
    Photograph.rankings.decrement(id, by)
  end

  class << self
    def rankings
      Redis::SortedSet.new('photograph_rankings')
    end

    def adjust_scores
      Photograph.find_each do |photograph|
        if photograph.score > 0
          decrease_by = photograph.score * 0.2
          photograph.decrement_score(decrease_by.to_i)
        end
      end
    end

    # Sorted by place in rankings
    #
    # @return [Array]
    def recommended(user, n = nil)
      Rails.cache.fetch([:photographs, :recommended, :sorted_photographs], expires_in: 1.minute) do
        photo_ids = if n.present? && n > 0
          Photograph.rankings.revrange(0,(n - 1))     
        else
          Photograph.rankings.members.reverse
        end
        photographs = Photograph.view_for(user).where(id: photo_ids).group_by(&:id)
        photo_ids.map { |id| photographs[id.to_i] }.compact.map(&:first)
      end
    end

    # Not sure why but combining scopes for this breaks it, so hardcoding it
    def view_for(user)
      if user.nil? || !user.show_nsfw_content
        includes(:metadata).where(safe_for_work: true).joins(:collections).where(collections: { public: true })
      else
        includes(:metadata).joins(:collections).where(collections: { public: true })
      end
    end
  end
end
