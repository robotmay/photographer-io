class AddStandardisedImageAccessorToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :standard_image_uid, :string
  end
end
