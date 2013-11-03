class License < ActiveRecord::Base
  extend FriendlyId

  has_many :photographs
  
  friendly_id :code, use: [:slugged, :finders]

  validates :name, :code, presence: true
end
