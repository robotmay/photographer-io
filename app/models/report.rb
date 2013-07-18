class Report < ActiveRecord::Base
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :reportable_id, :reportable_type, :user_id, :reason, presence: true
end
