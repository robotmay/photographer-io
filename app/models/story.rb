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

  def image
    case subject.class.to_s
    when "Favourite"
      subject.photograph.small_thumbnail_image
    when "Following"
      subject.follower.avatar
    else
      nil
    end
  end
end
