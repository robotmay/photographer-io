class Collection < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_many :collection_photographs
  has_many :photographs, through: :collection_photographs

  cache_belongs_to :user
  cache_has_many :photographs, inverse_name: :collections

  validates :user_id, :name, presence: true
end
