class AddGhostColumns < ActiveRecord::Migration
  def change
    add_column :photographs, :ghost, :boolean, default: false
    add_column :collections, :ghost, :boolean, default: false

    add_index :photographs, :ghost
    add_index :collections, :ghost
  end
end
