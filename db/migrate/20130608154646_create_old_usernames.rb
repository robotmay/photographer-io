class CreateOldUsernames < ActiveRecord::Migration
  def change
    create_table :old_usernames do |t|
      t.integer :user_id
      t.string :username

      t.timestamps
    end

    add_index :old_usernames, :user_id
    add_index :old_usernames, :username
  end
end
