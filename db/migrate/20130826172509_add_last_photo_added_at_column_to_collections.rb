class AddLastPhotoAddedAtColumnToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :last_photo_created_at, :datetime
  end
end
