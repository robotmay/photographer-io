class Favourite < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  belongs_to :photograph

  validates :user_id, :photograph_id, presence: true
end
