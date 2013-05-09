class AddRecommendationsCountColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recommendations_count, :integer
    User.find_each do |user|
      User.reset_counters(user.id, :recommendations)
    end
  end
end
