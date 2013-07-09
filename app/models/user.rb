class User < ActiveRecord::Base
  include Redis::Objects

  has_many :photographs, dependent: :destroy
  has_many :metadata, through: :photographs
  has_many :collections, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :recommended_photographs, through: :recommendations, source: :photograph
  has_many :received_recommendations, through: :photographs, source: :recommendations
  has_many :favourites, dependent: :destroy
  has_many :favourite_photographs, through: :favourites, source: :photograph
  has_many :received_favourites, through: :photographs, source: :favourites
  has_many :followee_followings, class_name: "Following", foreign_key: :followee_id
  has_many :followers, through: :followee_followings, source: :follower
  has_many :follower_followings, class_name: "Following", foreign_key: :follower_id
  has_many :followees, through: :follower_followings, source: :followee
  has_many :followee_photographs, through: :followees, source: :photographs
  has_many :invitations, class_name: self.to_s, as: :invited_by
  has_many :comment_threads
  has_many :comments
  has_many :notifications
  has_many :authorisations
  has_many :old_usernames

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  image_accessor :avatar

  hash_key :settings
  hash_key :seen
  counter :photograph_views
  counter :received_recommendations_count
  counter :received_favourites_count
  counter :followers_count
  value :last_checked_notifications_at

  validates :email, :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*\z/, message: I18n.t("users.username_format") }, length: { maximum: 50 }
  validates :website_url, format: URI::regexp(%w(http https)), allow_blank: true
  validate :username_has_not_been_used
  validate :username_quota_not_exceeded

  def username_has_not_been_used
    old = OldUsername.find_by(username: username)
    if old.present? && old.user_id != id
      errors.add(:username, I18n.t("users.old_username_present"))
    end
  end

  def username_quota_not_exceeded
    unless can_change_username?
      errors.add(:username, I18n.t("users.username_quota_exceeded"))
    end
  end

  def username_changes_remaining
    ISO[:defaults][:username_change_quota] - old_usernames.count
  end

  def can_change_username?
    username_changes_remaining > 0
  end

  before_create :set_defaults
  def set_defaults
    self.recommendation_quota = ISO[:defaults][:recommendation_quota]
    self.upload_quota = ISO[:defaults][:uploads_per_month]
  end

  before_validation :adjust_values
  def adjust_values
    if username_changed?
      self.username = username.downcase
    end
  end

  before_save :store_old_username
  def store_old_username
    if username_changed? && username_was.present?
      old_usernames.find_or_create_by(username: username_was)
    end
  end

  after_invitation_accepted :apply_referral_bonus
  def apply_referral_bonus
    n = ISO[:defaults][:upload_referral_bonus]
    increase_upload_quota(n)
    invited_by.increase_upload_quota(n)
  end

  after_create :create_default_records
  def create_default_records
    collections.create(name: "Public", visible: true)
    collections.create(name: "Private", visible: false)
  end

  def upload_count_for_this_month
    photographs.for_month(Date.today.beginning_of_month..Date.today.end_of_month).count
  end

  def remaining_uploads_for_this_month
    upload_quota - upload_count_for_this_month
  end

  def percentage_of_upload_quota_used_this_month
    decimal = upload_count_for_this_month.to_f / upload_quota.to_f
    decimal * 100
  end

  def increase_upload_quota(n)
    n ||= 0
    self.update_attribute(:upload_quota, upload_quota + n)
  end

  def recommendation_count_for_today
    recommendations.for_day(Date.today).count
  end

  def remaining_recommendations_for_today
    recommendation_quota - recommendation_count_for_today
  end

  def recommended?(photograph)
    recommended_photographs.include?(photograph) 
  end

  def favourited?(photograph)
    favourite_photographs.include?(photograph)
  end

  def following?(user)
    followees.include?(user)
  end

  def cover_photo_ids
    collections.map { |c| c.cover_photo_id.to_i }.compact
  end

  def website_host
    begin
      uri = URI.parse(website_url)
      uri.host
    rescue Exception
      website_url
    end
  end

  def push_stats
    PusherWorker.perform_async(channel_key, 'stats_update', {
      views: photograph_views.to_i,
      recommendations: received_recommendations_count.to_i,
      favourites: received_favourites_count.to_i,
      followers: followers_count.to_i
    })
  end

  def unread_notifications
    date = (last_checked_notifications_at.value || 1.year.ago).to_datetime
    notifications.where("created_at > ?", date)
  end

  def profile_background_photo
    #TODO Allow user to choose this
    photographs.visible.order("RANDOM()").first
  end

  class << self
    def find_by_id_or_username(param)
      case
      when param.to_i > 0
        User.find(param)
      else
        User.find_by(username: param)
      end
    end
  end
end
