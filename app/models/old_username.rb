class OldUsername < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
end
