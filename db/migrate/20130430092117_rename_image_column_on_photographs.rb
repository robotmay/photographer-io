class RenameImageColumnOnPhotographs < ActiveRecord::Migration
  def change
    rename_column :photographs, :image, :image_uid
  end
end
