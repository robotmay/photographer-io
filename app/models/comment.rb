class Comment < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :comment_thread, touch: true

  validates :user_id, :comment_thread_id, :body, presence: true

  scope :published, -> { where(published: true) }
end
