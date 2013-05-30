class Comment < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :comment_thread, touch: true
  has_many :notifications, as: :notifiable

  acts_as_tree dependent: :destroy

  validates :user_id, :comment_thread_id, :body, presence: true
  validates :parent_id, inclusion: { in: -> (c) { c.comment_thread.comments.pluck(:id) } }, allow_blank: true

  scope :published, -> { where(published: true) }

  after_create :notify
  def notify
    unless user == comment_thread.user
      title = comment_thread.threadable.title.blank? ? I18n.t("untitled") : comment_thread.threadable.title
      notifications.create(
        user: comment_thread.user,
        subject: I18n.t("comments.notifications.subject", user: user.name, on: title),
        body: I18n.t("comments.notifications.body", user: user.name, on: comment_thread.threadable.title)
      )
    end
  end

  def can_be_seen_by?(current_user)
    if current_user == user || current_user == comment_thread.user
      true
    elsif published?
      true
    else
      false
    end
  end

  def toggle_visibility
    self.published = !published
    saved = save

    if child? && saved && published
      self.ancestors.find_each do |a|
        a.update_attribute(:published, published)
      end
    end

    saved
  end
end
