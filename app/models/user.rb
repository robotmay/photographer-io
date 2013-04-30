class User < ActiveRecord::Base
  include IdentityCache

  has_many :photographs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
