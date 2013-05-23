class NotificationMailer < ActionMailer::Base
  default from: ISO[:from_email]
  layout 'mail'

  def notify(id)
    @notification = Notification.find(id)
    mail(
      to: @notification.user.email,
      subject: I18n.t("notifications.email.subject", subject: @notification.subject)
    )
  end
end
