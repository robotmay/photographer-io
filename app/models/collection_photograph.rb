class CollectionPhotograph < ActiveRecord::Base
  belongs_to :collection
  belongs_to :photograph

  validate :photograph_and_collection_should_belong_to_same_user
  def photograph_and_collection_should_belong_to_same_user
    if photograph.user != collection.user
      errors.add(:base, t("collection_photographs.user_must_match"))
    end
  end

  after_create :set_last_photo_created_at
  def set_last_photo_created_at
    if collection.last_photo_created_at.nil? || photograph.created_at > collection.last_photo_created_at
      collection.update_column(:last_photo_created_at, photograph.created_at) 
    end
  end
end
