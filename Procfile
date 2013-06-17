web: bundle exec puma -C ./config/puma.rb
worker: bundle exec sidekiq -q events,3 -q mailer,3 -q sunspot,2 -q photos,2 -q default,1 -q low -c 25
