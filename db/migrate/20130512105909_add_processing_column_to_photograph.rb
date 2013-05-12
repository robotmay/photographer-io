class AddProcessingColumnToPhotograph < ActiveRecord::Migration
  def change
    add_column :photographs, :processing, :boolean, default: false
    add_column :metadata, :processing, :boolean, default: false
  end
end
