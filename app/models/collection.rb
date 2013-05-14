class Collection < ActiveRecord::Base
  include IdentityCache

  belongs_to :user
  has_many :collection_photographs
  has_many :photographs, through: :collection_photographs

  cache_belongs_to :user

  paginates_per 50

  validates :user_id, :name, presence: true

  scope :public, -> { where(public: true) }
  scope :private, -> { where(private: true) }
  scope :view_for, -> (user) {
    joins(:photographs).merge(Photograph.view_for(user).except(:includes))
  }

  def cover_photo
    Rails.cache.fetch([self, :cover_photo]) do
      photographs.safe_for_work.where(processing: false).order("created_at DESC").first
    end
  end
end
