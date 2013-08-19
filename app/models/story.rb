class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :user_id, presence: true

  def text
    I18n.t(key, values)
  end

  def values
    super.symbolize_keys
  end
end
