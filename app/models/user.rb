class User < ActiveRecord::Base
  include IdentityCache
  include Redis::Objects

  has_many :photographs, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :recommended_photographs, through: :recommendations, source: :photograph
  has_many :favourites, dependent: :destroy
  has_many :favourite_photographs, through: :favourites, source: :photograph

  cache_has_many :photographs
  cache_has_many :collections

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  image_accessor :avatar

  counter :photograph_views

  validates :email, :name, presence: true

  before_create :set_defaults
  def set_defaults
    self.recommendation_quota = 10
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

  def website_host
    begin
      uri = URI.parse(website_url)
      uri.host
    rescue Exception
      website_url
    end
  end
end
