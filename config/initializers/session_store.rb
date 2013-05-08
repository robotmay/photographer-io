# Be sure to restart your server when you modify this file.
Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 30.days #NOTE: Do not set higher. Ever. Massive CSRF issues.
