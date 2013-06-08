class Category < ActiveRecord::Base
  include IdentityCache
  extend FriendlyId

  has_many :photographs
  has_many :collections, through: :photographs
  
  cache_index :slug, unique: true
  cache_has_many :photographs

  friendly_id :name, use: :slugged

  validates :name, presence: true
end
