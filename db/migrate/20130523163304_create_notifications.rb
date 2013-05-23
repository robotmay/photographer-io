class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :notifiable_id
      t.string :notifiable_type
      t.string :subject
      t.text :body

      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, [:notifiable_id, :notifiable_type]
  end
end
