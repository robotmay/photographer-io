class AddReadColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :read, :boolean, default: false
    add_index :notifications, :read
  end
end
