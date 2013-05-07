class AddCounterCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photographs_count, :integer
    User.find_each do |user|
      User.reset_counters(user.id, :photographs)
    end
  end
end
