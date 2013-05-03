class License < ActiveRecord::Base
  include IdentityCache

  has_many :photographs

  cache_has_many :photographs
end
