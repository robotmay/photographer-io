class AddDescriptionToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :description, :text
  end
end
