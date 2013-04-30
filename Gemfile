source 'https://rubygems.org'

gem 'rails', '4.0.0.beta1'

# databases
gem 'pg'

# caching
gem 'dalli'
gem 'identity_cache'
gem 'rack-cache'

# services
gem 'puma'
gem 'sidekiq'

# auth
gem 'devise'
# gem 'devise-scrypt' TODO: Switch to scrypt, gem needs updating
gem 'cancan'

# images
gem 'fog'
gem 'dragonfly'
gem 'mini_exiftool_vendored'

# views
gem 'slim'
gem 'simple_form'
gem 'link_to_active_state'

# assets
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.0.1'

# testing
group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'database_cleaner'
  gem 'machinist'
  gem 'ffaker'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-sidekiq'
  gem 'rb-inotify', '~> 0.8.8'
end
