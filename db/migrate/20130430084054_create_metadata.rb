class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.integer :photograph_id
      t.string :title
      t.text :description
      t.string :keywords, array: true

      t.timestamps
    end

    add_index :metadata, :photograph_id
  end
end
