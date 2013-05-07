class Collection < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_many :collection_photographs
  has_many :photographs, through: :collection_photographs

  cache_belongs_to :user

  validates :user_id, :name, presence: true

  scope :public, -> { where(public: true) }
  scope :private, -> { where(private: true) }
end
