class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name
      t.string :code

      t.timestamps
    end

    add_column :photographs, :license_id, :integer
    add_index :photographs, :license_id
  end
end
