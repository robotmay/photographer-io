class CreateCommentThreads < ActiveRecord::Migration
  def change
    create_table :comment_threads do |t|
      t.integer :user_id
      t.integer :threadable_id
      t.string :threadable_type
      t.text :subject

      t.timestamps
    end

    add_index :comment_threads, :user_id
    add_index :comment_threads, [:threadable_id, :threadable_type]
  end
end
