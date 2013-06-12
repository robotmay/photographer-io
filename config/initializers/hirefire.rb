HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    HireFire::Macro::Sidekiq.queue(:events, :mailer, :sunspot, :photos, :default, :low)
  end
end
