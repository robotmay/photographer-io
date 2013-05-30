class AddEmailColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :send_email, :boolean, default: false
  end
end
