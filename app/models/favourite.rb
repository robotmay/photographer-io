class Favourite < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :photograph

  validates :user_id, :photograph_id, presence: true

  after_create :adjust_photograph_score
  def adjust_photograph_score
    photograph.increment_score(1)
  end
end
