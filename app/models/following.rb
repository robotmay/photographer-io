class Following < ActiveRecord::Base
  belongs_to :followee, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :followee_id, :follower_id, presence: true
end
