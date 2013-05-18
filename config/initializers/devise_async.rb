Devise::Async.setup do |config|
  config.backend = :sidekiq
end

