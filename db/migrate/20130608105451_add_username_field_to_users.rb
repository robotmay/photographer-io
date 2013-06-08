class AddUsernameFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true

    User.find_each do |user|
      username = (user.name || "anon").parameterize.underscore

      i = 0
      while User.where(username: username).count > 0
        i += 1
        username = [username, i.to_s].join
      end

      user.update_attribute(:username, username)
    end
  end
end
