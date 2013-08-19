class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :subject_type
      t.string :key
      t.hstore :values

      t.timestamps
    end

    add_index :stories, :user_id
    add_index :stories, [:subject_id, :subject_type]
  end
end
