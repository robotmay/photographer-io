web: bundle exec puma -p $PORT
custom_web: bundle exec puma --bind 'unix:///tmp/web_server.sock' --pid '/tmp/web_server.pid' --environment $RAILS_ENV --threads 8:16
worker: bundle exec sidekiq
