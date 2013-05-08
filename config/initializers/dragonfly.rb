require 'dragonfly'
require 'rack/cache'

datastore = Dragonfly::DataStorage::S3DataStore.new(
  :region => ENV['S3_REGION'],
  :bucket_name => ENV['S3_BUCKET'],
  :access_key_id => ENV['S3_KEY'],
  :secret_access_key => ENV['S3_SECRET']
)

# Image store
app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.content_filename = proc do |job, request|
  if job.process_steps.any?
    "#{job.basename}_#{job.process_steps.first.name}.#{job.format}"
  else
    "#{job.basename}.#{job.format}"
  end
end

if ENV['S3_ENABLED']
  app.configure do |c|
    c.datastore = datastore
    c.protect_from_dos_attacks = true
    c.secret = ENV['DRAGONFLY_SECRET']
    c.url_format = "/media/:job/:basename.:format"
  end
else
  app.configure do |c|
    c.url_format = "/media/:job/:basename.:format"
  end
end

if ENV['CDN_HOST']
  app.cache_duration = 1.day
end

app.define_macro(ActiveRecord::Base, :image_accessor)

if !Rails.env.test? && defined?(Rack::Cache)
  Rails.application.middleware.insert_after Rack::Cache, Dragonfly::Middleware, :images
else
  Rails.application.middleware.insert 1, Dragonfly::Middleware, :images
end

