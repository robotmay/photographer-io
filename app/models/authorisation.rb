class Authorisation < ActiveRecord::Base
  belongs_to :user

  store_accessor :credentials, :token
  store_accessor :credentials, :expires_at

  validates :user_id, :provider, :uid, presence: true

  after_initialize :setup
  def setup
    case provider
    when 'google_oauth2'
      $google_plus.access_token = get_token
    end

    return self
  end

  def get_token
    if expires_at.present?
      if Time.at(expires_at.to_i) < Time.now
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
          self.token = body['access_token']
          self.expires_at = (Time.now + body['expires_in'].to_i).to_i
          save

          return 
        else
          nil
        end
      end
    end

    token
  end

  def profile
    @profile ||= case provider
    when 'google_oauth2'
      $google_plus.person
    end

    @profile
  end

  def mention(url)
    case provider
    when 'google_oauth2'
      $google_plus.insert_moment(url)
    end
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
