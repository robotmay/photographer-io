class AddFavouritesPrivacyOptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_favourites, :boolean, default: true
  end
end
