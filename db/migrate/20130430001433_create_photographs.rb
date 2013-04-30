class CreatePhotographs < ActiveRecord::Migration
  def change
    create_table :photographs do |t|
      t.integer :user_id
      t.string :image

      t.timestamps
    end

    add_index :photographs, :user_id
  end
end
