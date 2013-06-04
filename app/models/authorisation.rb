class Authorisation < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, :uid, presence: true

  def setup
    case provider
    when 'google_oauth2'
      GooglePlus.api_key = ENV['GOOGLE_API_KEY']
      GooglePlus.access_token = credentials['token']
    end

    return self
  end

  def token
    token = credentials['token']

    if credentials['expires_at'].present?
      if Time.at(credentials['expires_at'].to_i) < Time.now
        response = HTTParty.post("https://accounts.google.com/o/oauth2/token", {
          body: {
            client_id: ENV['GOOGLE_CLIENT_ID'],
            client_secret: ENV['GOOGLE_SECRET'],
            refresh_token: credentials['refresh_token'],
            grant_type: "refresh_token"
          }
        })

        if response.success?
          body = JSON.parse(response.body)
          self.credentials['token'] = body['access_token']
          self.credentials['expires_at'] = (Time.now + body['expires_in'].to_i).to_i
          save
          reload

          return credentials['token']
        else
          nil
        end
      end
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
