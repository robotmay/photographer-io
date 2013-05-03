class AddNewFieldsToUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
      t.string :location
      t.integer :default_license_id
    end
  end
end
