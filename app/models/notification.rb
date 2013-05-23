class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  delegate :url_helpers, to: 'Rails.application.routes' 

  validates :user_id, :notifiable_id, :notifiable_type, :subject, presence: true

  after_create :push
  def push
    PusherWorker.perform_async(user.channel_key, 'new_notification', {
      subject: subject,
      link: url_helpers.notification_path(self)
    })
  end

  after_create :email
  def email
    if user.receive_notification_emails
      NotificationMailer.delay.notify(id)
    end
  end
end
