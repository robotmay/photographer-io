class ChangeLastPhotoCreatedAtColumn < ActiveRecord::Migration
  def change
    rename_column :collections, :last_photo_created_at, :last_photo_added_at
  end
end
