class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment_thread, touch: true
  has_many :notifications, as: :notifiable

  acts_as_tree dependent: :destroy

  validates :user_id, :comment_thread_id, :body, presence: true
  validates :parent_id, inclusion: { in: -> (c) { c.comment_thread.comments.pluck(:id) } }, allow_blank: true

  scope :published, -> { where(published: true) }

  after_create :notify
  def notify
      # Notify owner
    unless user == comment_thread.user
      I18n.with_locale(comment_thread.user.locale) do
        title = comment_thread.threadable.title.blank? ? I18n.t("untitled") : comment_thread.threadable.title

        notifications.create(
          send_email: true,
          user: comment_thread.user,
          subject: I18n.t("comments.notifications.subject", user: user.name, on: title),
          body: I18n.t("comments.notifications.body", user: user.name, on: title)
        )
      end
    end
      
    # Notify replyee
    if child? && parent.user != comment_thread.user
      I18n.with_locale(parent.user.locale) do
        title = comment_thread.threadable.title.blank? ? I18n.t("untitled") : comment_thread.threadable.title

        notifications.create(
          user: parent.user,
          subject: I18n.t("comments.notifications.reply.subject", user: user.name, on: title),
          body: I18n.t("comments.notifications.reply.body", user: user.name, on: title)
        )
      end
    end
  end

  def can_be_seen_by?(current_user)
    Rails.cache.fetch([self, current_user]) do
      if current_user == user || current_user == comment_thread.user
        true
      elsif child? && ancestors.map(&:user).include?(current_user)
        true
      elsif published?
        true
      else
        false
      end
    end
  end

  def toggle_visibility
    self.published = !published
    saved = save

    if saved && published && user != comment_thread.user
      I18n.with_locale(user.locale) do
        title = comment_thread.threadable.title.blank? ? I18n.t("untitled") : comment_thread.threadable.title

        notifications.create(
          user: user,
          subject: I18n.t("comments.notifications.published.subject", on: title)
        )
      end
    end

    if child? && saved && published
      self.ancestors.find_each do |a|
        a.update_attribute(:published, published)
      end
    end

    saved
  end
end
