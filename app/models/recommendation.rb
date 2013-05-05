class Recommendation < ActiveRecord::Base
  belongs_to :photograph
  belongs_to :user

  validates :photograph_id, :user_id, presence: true
  validate :recommendation_quota_is_not_exceeded

  scope :for_day, lambda { |date|
    dt = date.to_datetime
    where("created_at >= ? AND created_at <= ?", dt.beginning_of_day, dt.end_of_day)
  }

  after_create :adjust_photograph_score
  def adjust_photograph_score
    photograph.increment_score
  end

  private
  def recommendation_quota_is_not_exceeded
    if user.remaining_recommendations_for_today == 0
      errors.add(:base, I18n.t("recommendations.user_quota_exceeded"))
    end
  end
end
