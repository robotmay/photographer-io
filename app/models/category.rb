class Category < ActiveRecord::Base
  include IdentityCache
  #extend FriendlyId

  has_many :photographs
  
  cache_index :slug, unique: true
  cache_has_many :photographs

  #friendly_id :name, use: :slugged

  validates :name, presence: true

  before_save :set_slug
  def set_slug
    #FIXME: Replace with friendly_id when it doesn't throw errors all the time
    self.slug = name.parameterize
  end
end
