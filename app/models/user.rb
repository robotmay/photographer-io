class User < ActiveRecord::Base
  include IdentityCache

  has_many :photographs, dependent: :destroy
  has_many :collections, dependent: :destroy

  cache_has_many :photographs
  cache_has_many :collections

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  image_accessor :avatar

  validates :email, :name, presence: true
end
