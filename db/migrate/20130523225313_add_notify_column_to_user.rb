class AddNotifyColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_notification_emails, :boolean, default: true
  end
end
