class AddSlugToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :slug, :string
    add_index :licenses, :slug
  end
end
