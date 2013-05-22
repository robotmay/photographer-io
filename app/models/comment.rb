class Comment < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :comment_thread, touch: true

  acts_as_tree dependent: :destroy

  validates :user_id, :comment_thread_id, :body, presence: true
  validates :parent_id, inclusion: { in: -> (c) { c.comment_thread.comments.pluck(:id) } }, allow_blank: true

  scope :published, -> { where(published: true) }

  def can_be_seen_by?(current_user)
    if current_user == user || current_user == comment_thread.user
      true
    elsif published?
      true
    else
      false
    end
  end
end
