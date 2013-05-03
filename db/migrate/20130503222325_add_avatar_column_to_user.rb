class AddAvatarColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar_uid, :string
  end
end
