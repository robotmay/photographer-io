class Collection < ActiveRecord::Base
  include IdentityCache

  belongs_to :user

  cache_belongs_to :user

  validates :user_id, :name, presence: true
end
