HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    HireFire::Macro::Sidekiq.queue(:events, :mailer, :sunspot, :default, :low)
  end

  config.dyno(:photos) do
    HireFire::Macro::Sidekiq.queue(:photos)
  end
end
