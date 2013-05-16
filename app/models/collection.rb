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

  def cover_photo(category = nil)
    Rails.cache.fetch([self, :cover_photo, category]) do
      photos = photographs.safe_for_work.where(processing: false).order("created_at DESC")
      if category.present?
        photos = photos.where(category_id: category.id)
      end

      photo = if user.already_used_collection_cover_photos.size > 0
        filtered_photos = photos.where.not(id: user.already_used_collection_cover_photos)
        photo = filtered_photos.first || photos.first
        user.already_used_collection_cover_photos << photo.id
        photo
      else
        photos.first
      end
      
      photo
    end
  end
end
