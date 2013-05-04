class AddShowNotSafeForWorkColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_nsfw_content, :boolean, default: false
  end
end
