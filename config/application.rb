require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Iso
  def set_db_connection_pool_size!(size=20)
    # bump the AR connection pool
    if ENV['DATABASE_URL'].present? && ENV['DATABASE_URL'] !~ /pool/
      pool_size = ENV.fetch('DATABASE_POOL_SIZE', size)
      db = URI.parse ENV['DATABASE_URL']
      if db.query
        db.query += "&pool=#{pool_size}"
      else
        db.query = "pool=#{pool_size}"
      end
      ENV['DATABASE_URL'] = db.to_s
      ActiveRecord::Base.establish_connection
    end
  end

  module_function :set_db_connection_pool_size!

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    config.active_record.schema_format = :sql
    config.assets.precompile += %w( custom.modernizr.js )

    if Puma.respond_to?(:cli_config)
      ::Iso.set_db_connection_pool_size! Puma.cli_config.options.fetch(:max_threads)
    end
  end
end
