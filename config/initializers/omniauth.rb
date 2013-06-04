Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'], {
    scope: "userinfo.email,plus.login",
    request_visible_actions: "http://schemas.google.com/CreateActivity"
  }
end
