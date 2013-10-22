class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  delegate :url_helpers, to: 'Rails.application.routes' 
  
  paginates_per 10

  validates :user_id, :notifiable_id, :notifiable_type, :subject, presence: true

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  after_commit :push, on: :create
  def push
    PusherWorker.perform_async(user.channel_key, 'new_notification', {
      subject: subject,
      link: url_helpers.notification_path(self)
    })
  end

  after_commit :email, on: :create
  def email
    if user.receive_notification_emails && send_email?
      NotificationMailer.delay.notify(id)
    end
  end

  def unread?
    !read
  end

  def mark_as_read
    self.update_attribute(:read, true)
  end

  def image
    case notifiable.class.to_s
    when "Favourite"
      notifiable.photograph.small_thumbnail_image
    when "Following"
      notifiable.follower.avatar
    else
      nil
    end
  end
end
