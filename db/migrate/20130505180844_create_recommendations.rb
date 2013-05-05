class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :photograph_id
      t.integer :user_id

      t.timestamps
    end

    add_index :recommendations, :photograph_id
    add_index :recommendations, :user_id
  end
end
