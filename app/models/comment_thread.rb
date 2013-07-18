class CommentThread < ActiveRecord::Base
  belongs_to :user
  belongs_to :threadable, polymorphic: true, touch: true
  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  validates :user_id, :threadable_id, :threadable_type, presence: true

  before_validation :set_defaults
  def set_defaults
    self.user = case
    when threadable.is_a?(User)
      threadable
    when threadable.present? && threadable.respond_to?(:user)
      threadable.user
    end
  end
end
