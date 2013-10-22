class AddSmallThumbnailImageColumnToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :small_thumbnail_image_uid, :string
  end
end
