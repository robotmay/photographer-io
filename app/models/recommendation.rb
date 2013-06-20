class Recommendation < ActiveRecord::Base
  belongs_to :photograph, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :photograph_id, :user_id, presence: true
  validate :recommendation_quota_is_not_exceeded

  scope :for_day, lambda { |date|
    dt = date.to_datetime
    where("created_at >= ? AND created_at <= ?", dt.beginning_of_day, dt.end_of_day)
  }

  after_create :adjust_photograph_score
  def adjust_photograph_score
    photograph.increment_score(3)
  end

  after_create do
    photograph.user.received_recommendations_count.increment
    photograph.user.push_stats
    KeenWorker.perform_async(:recommendations, { 
      photograph: {
        id: photograph.id,
        category: photograph.category.try(:name)
      },
      user: {
        id: user.id,
        name: user.name
      }
    })
  end

  private
  def recommendation_quota_is_not_exceeded
    if user.remaining_recommendations_for_today == 0
      errors.add(:base, I18n.t("recommendations.user_quota_exceeded"))
    end
  end
end
