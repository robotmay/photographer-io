class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug, unique: true

      t.timestamps
    end

    add_index :categories, :slug

    add_column :photographs, :category_id, :integer
    add_index :photographs, :category_id
  end
end
