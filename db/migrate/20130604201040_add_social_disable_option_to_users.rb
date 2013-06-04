class AddSocialDisableOptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_social_buttons, :boolean, default: true
  end
end
