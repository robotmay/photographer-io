class Category < ActiveRecord::Base
  extend FriendlyId

  has_many :photographs
  has_many :collections, through: :photographs
  
  friendly_id :name, use: :slugged

  validates :name, presence: true
end
