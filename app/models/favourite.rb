class Favourite < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :photograph, counter_cache: true

  validates :user_id, :photograph_id, presence: true

  after_create :adjust_photograph_score
  def adjust_photograph_score
    photograph.increment_score(1)
  end

  after_create do
    photograph.user.received_favourites_count.increment
    photograph.user.push_stats
  end
end
