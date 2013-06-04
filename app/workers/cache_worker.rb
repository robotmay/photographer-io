class CacheWorker
  include Sidekiq::Worker

  def perform(key, value, options = {})
    Rails.cache.write(key, value, options)
  end
end
