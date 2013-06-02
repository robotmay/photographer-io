class AddSharingOptionToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :shared, :boolean, default: false
    add_column :collections, :encrypted_password, :string
  end
end
