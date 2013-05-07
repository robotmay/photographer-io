class AddShowCopyrightOptions < ActiveRecord::Migration
  def change
    add_column :users, :show_copyright_info, :boolean, default: true
    add_column :photographs, :show_copyright_info, :boolean, default: false
  end
end
