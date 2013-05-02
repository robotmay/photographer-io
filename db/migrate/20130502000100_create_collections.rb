class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :user_id
      t.string :name
      t.boolean :public, default: false

      t.timestamps
    end

    add_index :collections, :user_id
    add_index :collections, :public
  end
end
