class Following < ActiveRecord::Base
  belongs_to :followee, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :followee_id, :follower_id, presence: true

  after_create do
    followee.followers_count.increment
    followee.push_stats
  end

  after_destroy do
    followee.followers_count.decrement
    followee.push_stats
  end
end
