source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'

# databases
gem 'pg'

# caching
gem 'dalli'
gem 'identity_cache'
gem 'rack-cache'

# services
gem 'puma'
gem 'unicorn'
gem 'sidekiq'

# auth
gem 'devise', git: 'git://github.com/plataformatec/devise.git', branch: 'rails4'
# gem 'devise-scrypt' TODO: Switch to scrypt, gem needs updating
gem 'cancan'

# images
gem 'fog'
gem 'dragonfly'
gem 'mini_exiftool_vendored'

# views
gem 'slim'
gem 'simple_form', '~> 3.0.0.beta1'
gem 'link_to_active_state'
gem 'kaminari'

# assets
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
  gem 'zurb-foundation', '~> 4.0.0'
end

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.0.1'
gem 'quiet_assets'

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
