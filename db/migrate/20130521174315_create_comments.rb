class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :comment_thread_id
      t.integer :user_id
      t.text :body
      t.boolean :published

      t.timestamps
    end

    add_index :comments, :comment_thread_id
    add_index :comments, :user_id
    add_index :comments, :published
    add_index :comments, [:comment_thread_id, :published]

    add_column :photographs, :enable_comments, :boolean, default: false
    add_column :users, :enable_comments, :boolean, default: false
  end
end
