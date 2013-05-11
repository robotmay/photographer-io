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

  after_commit :push, on: :create
  def push
    begin
      Pusher.trigger(user.channel_key, 'new_recommendation', {
        photograph_id: photograph_id,
        photograph_recommendations_count: photograph.recommendations_count
      })
    rescue Pusher::Error
      #
    end
  end

  private
  def recommendation_quota_is_not_exceeded
    if user.remaining_recommendations_for_today == 0
      errors.add(:base, I18n.t("recommendations.user_quota_exceeded"))
    end
  end
end
