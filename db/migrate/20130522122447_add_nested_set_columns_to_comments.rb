class AddNestedSetColumnsToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.integer :parent_id
    end

    add_index :comments, :parent_id

    create_table :comment_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false
      t.integer  :descendant_id, :null => false
      t.integer  :generations, :null => false
    end

    add_index :comment_hierarchies, [:ancestor_id, :descendant_id], :unique => true
    add_index :comment_hierarchies, [:descendant_id]
  end
end
