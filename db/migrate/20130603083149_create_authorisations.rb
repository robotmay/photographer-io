class CreateAuthorisations < ActiveRecord::Migration
  def change
    create_table :authorisations do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.hstore :info
      t.hstore :credentials
      t.hstore :extra

      t.timestamps
    end

    add_index :authorisations, :user_id
    add_index :authorisations, [:user_id, :provider]
    add_index :authorisations, [:provider, :uid]
  end
end
