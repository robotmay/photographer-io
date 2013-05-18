class AddUploadQuotaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upload_quota, :integer
    User.find_each do |user|
      user.upload_quota = ISO[:defaults][:uploads_per_month]
      user.save
    end
  end
end
