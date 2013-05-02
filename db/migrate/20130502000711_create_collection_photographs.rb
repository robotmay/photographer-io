class CreateCollectionPhotographs < ActiveRecord::Migration
  def change
    create_table :collection_photographs do |t|
      t.integer :collection_id
      t.integer :photograph_id

      t.timestamps
    end

    add_index :collection_photographs, :collection_id
    add_index :collection_photographs, :photograph_id
  end
end
