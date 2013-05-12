class AddMimeTypeToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :image_mime_type, :string
  end
end
