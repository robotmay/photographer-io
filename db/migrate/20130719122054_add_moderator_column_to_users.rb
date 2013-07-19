class AddModeratorColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :moderator, :boolean, default: false
  end
end
