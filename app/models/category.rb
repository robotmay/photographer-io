class Category < ActiveRecord::Base
  extend FriendlyId

  has_many :photographs
  has_many :collections, through: :photographs
  
  friendly_id :name, use: :slugged

  validates :name, presence: true

  def name
    name = read_attribute(:name)
    I18n.t(name.downcase.parameterize.underscore, scope: [:categories], default: name)
  end
end
