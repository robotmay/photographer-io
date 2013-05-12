class AddMagicAttributesToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :image_name, :string
    add_column :photographs, :image_ext, :string
    add_column :photographs, :image_size, :integer
  end
end
