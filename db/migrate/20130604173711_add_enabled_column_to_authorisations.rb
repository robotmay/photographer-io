class AddEnabledColumnToAuthorisations < ActiveRecord::Migration
  def change
    add_column :authorisations, :auto_post, :boolean, default: false
    add_index :authorisations, [:user_id, :auto_post]

    add_column :photographs, :auto_mentioned, :boolean, default: false
  end
end
