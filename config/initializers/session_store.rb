# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 30.days #NOTE: Do not set higher. Ever. Massive CSRF issues.
else
  Rails.application.config.session_store :cookie_store, key: '_pio_session'
end
