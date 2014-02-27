source 'https://code.stripe.com'
source 'https://rubygems.org'

def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ && require_as
end

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ && require_as
end

ruby '2.0.0'

gem 'rails', '4.0.3'
gem 'sinatra', '>= 1.3.0', require: nil

# deployment
gem 'capistrano'
gem 'capistrano-foreman'
gem 'whenever'
gem 'dotenv-rails'
gem 'foreman'

# utilities
gem 'thread'
gem 'httparty'
gem 'oj'

# debugging
gem 'pry'
gem 'pry-rails'

# databases
gem 'pg'

# search
gem 'pg_search'
gem 'pg_array_parser'

# redis
gem 'redis-objects'

# caching
gem 'dalli'
gem 'kgio'
gem 'rack-cache'
gem 'multi_fetch_fragments', github: 'robotmay/multi_fetch_fragments'

# services
gem 'puma', '2.6.0'
gem 'sidekiq', '2.15.2'
gem 'sidekiq-limit_fetch'
gem 'airbrake'
gem 'newrelic_rpm'
gem 'postmark-rails'
gem 's3'
gem 'pubnub'
gem 'gabba'
gem 'stripe'
gem 'keen'
gem 'coveralls', require: false

# auth
gem 'devise', '~> 3.0.0'
gem 'devise_invitable', '~> 1.2.1'
gem 'devise-async', '~> 0.8.0'
gem 'cancan'

# omniauth
gem 'omniauth-google-oauth2', github: 'murryivanoff/omniauth-google-oauth2'

# images
gem 'fog'
gem 'dragonfly', '~> 0.9.15'
gem 'mini_exiftool_vendored'
gem 's3_direct_upload'

# views
gem 'slim', '>= 1.3.0'
gem 'simple_form', '~> 3.0.1'
gem 'link_to_active_state'
gem 'kaminari'
gem 'redcarpet'

# models
gem 'friendly_id', '5.0.0.rc1'
gem 'closure_tree'

# assets
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
  gem 'zurb-foundation', '~> 4.1.6'
end

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.0.1'
gem 'quiet_assets'
gem 'i18n-js', '~> 3.0.0.rc5'

# testing
group :development, :test do
  # specs
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'database_cleaner'
  gem 'machinist'
  gem 'ffaker'

  # acceptance testing
  gem 'capybara'

  # continuous testing
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-sidekiq'
  gem 'rb-inotify', '~> 0.9', :require => linux_only('rb-inotify')
  gem 'rb-fsevent', :require => darwin_only('rb-fsevent')

  # mailers
  gem 'letter_opener'

  # utility
  gem 'launchy'
  gem 'timecop'
end
