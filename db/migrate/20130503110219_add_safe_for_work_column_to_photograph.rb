class AddSafeForWorkColumnToPhotograph < ActiveRecord::Migration
  def change
    add_column :photographs, :safe_for_work, :boolean, default: true
    add_index :photographs, :safe_for_work
  end
end
