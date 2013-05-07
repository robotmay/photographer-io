class CollectionPhotograph < ActiveRecord::Base
  belongs_to :collection
  belongs_to :photograph

  validate :photograph_and_collection_should_belong_to_same_user
  def photograph_and_collection_should_belong_to_same_user
    if photograph.user != collection.user
      errors.add(:base, t("collection_photographs.user_must_match"))
    end
  end
end
