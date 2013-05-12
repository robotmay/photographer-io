class AddNewImageUidsToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :homepage_image_uid, :string
    add_column :photographs, :large_image_uid, :string
    add_column :photographs, :thumbnail_image_uid, :string
  end
end
