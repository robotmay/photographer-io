class Authorisation < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, :uid, presence: true

  def setup
    case provider
    when 'gplus'
      GooglePlus.access_token = credentials['token']
    end
  end

  def token
    token = credentials['token']

    if credentials['expires'] == 'true'

    end

    token
  end

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      auth = find_or_create_by(
        provider: auth_hash['provider'],
        uid: auth_hash['uid']
      )

      if auth && auth.persisted?
        auth.update_attributes(
          info: auth_hash['info'],
          credentials: auth_hash['credentials'],
          extra: auth_hash['extra']
        )
      end

      auth
    end
  end
end
