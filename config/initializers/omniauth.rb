Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gplus, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET']
end
