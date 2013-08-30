class CollectionPhotograph < ActiveRecord::Base
  belongs_to :collection
  belongs_to :photograph

  validate :photograph_and_collection_should_belong_to_same_user
  def photograph_and_collection_should_belong_to_same_user
    if photograph.user != collection.user
      errors.add(:base, t("collection_photographs.user_must_match"))
    end
  end

  after_create :set_last_photo_added_at
  def set_last_photo_added_at
    now = Time.now

    if collection.last_photo_added_at.nil? || now > collection.last_photo_added_at
      collection.update_column(:last_photo_added_at, now) 
      collection.touch
    end
  end
end
