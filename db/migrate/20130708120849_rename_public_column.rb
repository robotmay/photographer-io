class RenamePublicColumn < ActiveRecord::Migration
  def change
    rename_column :collections, :public, :visible
  end
end
