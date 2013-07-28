class Collection < ActiveRecord::Base
  include Redis::Objects

  belongs_to :user
  has_many :collection_photographs
  has_many :photographs, through: :collection_photographs
  has_many :reports, as: :reportable

  paginates_per 50

  attr_accessor :password
  value :cover_photo_id

  counter :views

  validates :user_id, :name, presence: true

  scope :visible, -> { where(visible: true) }
  scope :hidden, -> { where(visible: false) }
  scope :shared, -> { where(shared: true) }
  scope :view_for, -> (user) {
    joins(:photographs).merge(Photograph.view_for(user).except(:includes))
  }

  before_save :update_password
  def update_password
    if @password.present?
      self.encrypted_password = SCrypt::Password.create(@password)
    end
  end

  def encrypted_password
    SCrypt::Password.new read_attribute(:encrypted_password)
  end

  def authenticated?
    encrypted_password == password
  end

  def requires_password?
    !!encrypted_password
  end

  def cover_photo(category = nil)
    #TODO Allow user to specify the cover image for the collection
    Rails.cache.fetch([self, :cover_photo, category], expires_in: 1.hour) do
      photos = photographs.safe_for_work.not_processing.not_ghost.order("created_at DESC")
      if category.present?
        photos = photos.where(category_id: category.id)
      end

      photo = if user.cover_photo_ids.size > 0
        filtered_photos = photos.where.not(id: user.cover_photo_ids)
        filtered_photos.first || photos.first
      else
        photos.first
      end
      
      if photo.present?
        self.cover_photo_id = photo.id
        photo
      else
        nil
      end
    end
  end

  def reset_cover_photo(category = nil)
    Rails.cache.delete([self, :cover_photo, category])
  end

  def ghost!
    self.ghost = true
    save
  end
end
