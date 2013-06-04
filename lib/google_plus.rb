class GooglePlus
  include HTTParty
  base_uri "https://www.googleapis.com/plus/v1/"
  headers "Content-Type" => "application/json"

  attr_accessor :credentials, :access_token

  def initialize(credentials = {})
    self.credentials = credentials
  end

  def access_token=(token)
    @access_token = token
    self.class.default_params access_token: @access_token
    @access_token
  end

  def person(id = 'me', opts = {})
    self.class.get("/people/#{id}", opts)
  end

  def insert_moment(target_url)
    data = {
      type: "http://schemas.google.com/CreateActivity",
      target: {
        url: target_url
      }
    }
    self.class.post("/people/me/moments/vault", {
      body: data.to_json
    })
  end
end
