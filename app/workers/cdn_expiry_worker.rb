class CDNExpiryWorker
  include Sidekiq::Worker

  def perform(paths = [])
    raise "Requires distribution ID" if ENV['CDN_DISTRIBUTION'].nil?
    distribution = $cdn.distributions.get(ENV['CDN_DISTRIBUTION'])
    invalidation = distribution.invalidations.create(paths: paths)
    invalidation.wait_for { ready? }
  end
end
