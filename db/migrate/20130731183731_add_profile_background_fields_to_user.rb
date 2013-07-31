class AddProfileBackgroundFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_profile_background, :boolean, default: true
    add_column :users, :profile_background_photo_id, :integer
  end
end
