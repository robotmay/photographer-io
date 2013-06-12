class Photograph < ActiveRecord::Base
  include IdentityCache
  include Redis::Objects

  belongs_to :user, counter_cache: true
  belongs_to :license
  belongs_to :category
  has_one :metadata, dependent: :delete
  has_many :collection_photographs, dependent: :destroy
  has_many :collections, through: :collection_photographs
  has_many :recommendations
  has_many :favourites
  has_many :favourited_by_users, through: :favourites, source: :user
  has_many :comment_threads, as: :threadable
  has_many :comments, through: :comment_threads

  cache_belongs_to :user
  cache_belongs_to :license
  cache_belongs_to :category
  cache_has_one :metadata, embed: true
  cache_has_many :collections, inverse_name: :photographs
  cache_has_many :recommendations

  delegate :title, :description, :keywords, :format, :landscape?, :portrait?, 
           :square?, to: :metadata
  delegate :url_helpers, to: 'Rails.application.routes'

  paginates_per 35
  image_accessor :image do
    storage_opts do |i|
      { storage_headers: { 'x-amz-acl' => 'private' } }
    end
  end

  image_accessor :standard_image do
    storage_path { |i| image_storage_path(i) }
  end

  image_accessor :homepage_image do
    storage_path { |i| image_storage_path(i) }
  end

  image_accessor :large_image do
    storage_path { |i| image_storage_path(i) }
  end

  image_accessor :thumbnail_image do
    storage_path { |i| image_storage_path(i) }
  end

  counter :views
  value :highest_rank

  accepts_nested_attributes_for :metadata, update_only: true
  accepts_nested_attributes_for :collections
  accepts_nested_attributes_for :comment_threads, allow_destroy: true, reject_if: -> (ct) { ct[:subject].blank? }

  validates :user_id, :image_uid, presence: true
  validates :image_mime_type, inclusion: { in: ["image/jpeg"] }, on: :create
  validates :image_size, numericality: { less_than_or_equal_to: 30.megabytes }, on: :create
  validate :upload_quota_is_not_exceeded

  scope :processing, -> {
    where(processing: true)
  }
  scope :not_processing, -> {
    where(processing: false).joins(:metadata).where(metadata: { processing: false })
  }
  scope :public, -> {
    not_processing.joins(:collections).where(collections: { public: true })
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
  scope :landscape, -> { 
    joins(:metadata).merge(Metadata.format('landscape'))
  }
  scope :portrait, -> {
    joins(:metadata).merge(Metadata.format('portrait'))
  }
  scope :square, -> {
    joins(:metadata).merge(Metadata.format('square'))
  }
  scope :for_month, -> (date_range) {
    where(created_at: date_range)
  }
  
  searchable do
    text :title do |photo|
      photo.metadata.title
    end

    text :description do |photo|
      photo.metadata.description
    end

    string :keywords, multiple: true do |photo|
      photo.metadata.keywords
    end

    text :creator_name do |photo|
      photo.user.name
    end

    integer :user_id, references: User
    integer :license_id, references: License
    integer :category_id, references: Category
    integer :collection_ids, references: Collection, multiple: true do |photo|
      photo.collections.pluck(:id)
    end
    float :score
    time :created_at
    boolean :public, using: :public?
  end

  def favourites_count
    super || 0
  end

  def recommendations_count
    super || 0
  end

  def image_storage_path(i)
    name = File.basename(image_uid, (image_ext || ".jpg"))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join("/")
  end

  def public?
    collections.where(public: true).count > 0
  end

  def exif
    Photograph.benchmark "Parsing image for EXIF" do
      MiniExiftool.new(image.file.path)
    end
  end

  before_create :set_defaults_from_user_settings
  def set_defaults_from_user_settings
    self.processing = true
    self.license_id = user.default_license_id
    self.show_location_data = user.show_location_data
    self.show_copyright_info = user.show_copyright_info
    return
  end

  before_create :extract_metadata
  def extract_metadata
    self.metadata = Metadata.new(photograph: self) if metadata.nil?
  end

  after_create :save_metadata
  def save_metadata
    metadata.save
  end

  after_commit :create_sizes, on: :create
  def create_sizes
    PhotoExpansionWorker.perform_async(id)
  end

  after_save { MentionWorker.perform_async(id) }
  def auto_mention
    if self.public? && !auto_mentioned
      user.authorisations.auto_post.each do |a|
        a.mention url_helpers.photograph_url(self, host: ENV['DOMAIN'])
        Rails.logger.info "Mentioned on #{a.provider} for #{a.uid}"
      end

      self.update_attribute(:auto_mentioned, true)
    end
  end

  after_commit :complete_image_processing, on: :update
  def complete_image_processing
    if processing
      reload
      if has_image_sizes? && !metadata.processing
        self.processing = false
        save
        trigger_image_processed_push
      end
    end
  end

  after_destroy :expire_from_cdn
  def expire_from_cdn
    paths = [:standard_image, :homepage_image, :large_image, :thumbnail_image].map do |m|
      url = self.send(m).try(:remote_url)
      unless url.nil?
        uri = URI.parse(URI.escape(url))
        uri.path
      end
    end

    paths.compact!

    CDNExpiryWorker.perform_async(paths)
  end

  def build_comment_threads
    (ISO[:defaults][:max_comment_threads] - comment_threads.count).times do
      comment_threads.build
    end
  end

  def has_image_sizes?
    standard_image.present? && homepage_image.present? && large_image.present? && thumbnail_image.present?
  end

  def processing?
    processing || metadata.processing
  end

  def comments_enabled?
    enable_comments
  end

  def has_precalculated_sizes?
    (large_image.present? && homepage_image.present? && thumbnail_image.present?) || processing?
  end

  def score
    Photograph.rankings[id]
  end

  def rank
    Photograph.rankings.rank(id)
  end

  def set_highest_rank
    if rank.present? && rank > highest_rank.to_i
      self.highest_rank = rank
    end
  end

  def increment_score(by = 1)
    Photograph.rankings.increment(id, by) do
      set_highest_rank
    end
  end

  def decrement_score(by = 1)
    set_highest_rank
    Photograph.rankings.decrement(id, by)
  end

  def trigger_image_processed_push
    unless processing?
      push
    end
  end

  def push
    if ENV['CDN_HOST']
      large = large_image.remote_url(host: ENV['CDN_HOST'])
      thumb = thumbnail_image.remote_url(host: ENV['CDN_HOST'])
    else
      large = large_image.remote_url
      thumb = thumbnail_image.remote_url
    end

    PusherWorker.perform_async(user.channel_key, 'image_processed', {
      id: id,
      large: large,
      thumbnail: thumb
    })
  end

  class << self
    def new_from_s3_upload(user, params)
      user.photographs.new do |p|
        p.image_uid = Photograph.prepare_image_uid(params[:filepath])
        p.image_name = params[:filename]
        p.image_ext = File.extname(params[:filename])
        p.image_size = params[:filesize]
        p.image_mime_type = params[:filetype]
      end
    end

    def prepare_image_uid(s3_upload_path)
      s3_upload_path.gsub!(ENV['S3_BUCKET'], "") if ENV['S3_BUCKET']
      s3_upload_path.gsub!("//", "")
      s3_upload_path.gsub!("+", " ")
      URI.unescape(s3_upload_path)
    end

    def rankings
      Redis::SortedSet.new('photograph_rankings')
    end

    def median_score(n)
      members = Photograph.rankings.members(with_scores: true).reverse.take(n)
      members.map(&:last).median
    end

    def adjust_scores
      Photograph.recommended(nil, 20).each do |photograph|
        if photograph.score > 0
          if photograph.score > (median_score(20) * 2)
            decrease_by = photograph.score * 0.5
            photograph.decrement_score(decrease_by.to_i)
          elsif photograph.created_at < 1.day.ago
            decrease_by = photograph.score * 0.1
            photograph.decrement_score(decrease_by.to_i)
          end
        end
      end
    end

    # Sorted by place in rankings
    #
    # @return [Array]
    def recommended(user = nil, n = nil)
      photo_ids = if n.present? && n > 0
        Photograph.rankings.revrange(0,(n - 1))     
      else
        Photograph.rankings.members.reverse
      end
      
      photographs = view_for(user).includes(:metadata).where(id: photo_ids).group_by(&:id)

      photo_ids.map { |id| photographs[id.to_i] }.compact.map(&:first)
    end

    # Not sure why but combining scopes for this breaks it, so hardcoding it
    def view_for(user)
      if user.nil? || !user.show_nsfw_content
        where(safe_for_work: true).joins(:collections).where(collections: { public: true }).where(processing: false).includes(:metadata, :user)
      else
        joins(:collections).where(collections: { public: true }).where(processing: false).includes(:metadata, :user)
      end
    end
  end

  private
  def upload_quota_is_not_exceeded
    if user.remaining_uploads_for_this_month == 0
      errors.add(:base, I18n.t("photographs.user_quota_exceeded"))
    end
  end
end
