class AddRecommendationQuotaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recommendation_quota, :integer
  end
end
