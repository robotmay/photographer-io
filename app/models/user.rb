class User < ActiveRecord::Base
  include IdentityCache
  include Redis::Objects

  has_many :photographs, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :recommended_photographs, through: :recommendations, source: :photograph

  cache_has_many :photographs
  cache_has_many :collections
  cache_has_many :recommendations

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  image_accessor :avatar

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
end
