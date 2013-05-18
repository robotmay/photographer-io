class User < ActiveRecord::Base
  include IdentityCache
  include Redis::Objects

  has_many :photographs, dependent: :destroy
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

  cache_has_many :photographs
  cache_has_many :collections

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  image_accessor :avatar

  hash_key :settings
  counter :photograph_views
  counter :received_recommendations_count
  counter :received_favourites_count

  validates :email, :name, presence: true

  before_create :set_defaults
  def set_defaults
    self.recommendation_quota = ISO[:defaults][:recommendation_quota]
    self.upload_quota = ISO[:defaults][:uploads_per_month]
  end

  def upload_count_for_this_month
    photographs.for_month(Date.today.beginning_of_month..Date.today.end_of_month).count
  end

  def remaining_uploads_for_this_month
    upload_quota - upload_count_for_this_month
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
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          Pusher.trigger(channel_key, 'stats_update', {
            views: photograph_views.to_i,
            recommendations: received_recommendations_count.to_i,
            favourites: received_favourites_count.to_i
          })
        rescue Pusher::Error
        end
      end
    end
  end
end
