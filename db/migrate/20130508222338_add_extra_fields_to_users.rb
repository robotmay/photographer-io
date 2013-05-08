class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :biography, :text
    add_column :users, :website_url, :string
  end
end
