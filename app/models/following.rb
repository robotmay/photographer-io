class Following < ActiveRecord::Base
  belongs_to :followee, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  has_many :notifications, as: :notifiable

  validates :followee_id, :follower_id, presence: true

  after_create do
    followee.followers_count.increment
    followee.push_stats
    notify
  end

  after_destroy do
    followee.followers_count.decrement
    followee.push_stats
  end

  def notify
    I18n.with_locale(followee.locale) do
      notifications.create(
        user: followee,
        subject: I18n.t("followings.notifications.subject", user: follower.name)
      )
    end
  end
end
