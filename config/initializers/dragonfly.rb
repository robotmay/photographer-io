require 'dragonfly'
require 'rack/cache'

datastore = Dragonfly::DataStorage::S3DataStore.new(
  :bucket_name => ENV['S3_BUCKET'],
  :access_key_id => ENV['S3_KEY'],
  :secret_access_key => ENV['S3_SECRET']
)

# Image store
app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

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

app.define_macro(ActiveRecord::Base, :image_accessor)

if Rails.env.production? && defined?(Rack::Cache)
  Rails.application.middleware.insert_after Rack::Cache, Dragonfly::Middleware, :images
else
  Rails.application.middleware.insert 1, Dragonfly::Middleware, :images
end

