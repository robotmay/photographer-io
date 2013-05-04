class AddLocationOptionFieldsToPhotoAndUser < ActiveRecord::Migration
  def change
    add_column :photographs, :show_location_data, :boolean, default: false
    add_column :users, :show_location_data, :boolean, default: false
  end
end
