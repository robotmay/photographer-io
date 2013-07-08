web: bundle exec puma -p 5000
worker: bundle exec sidekiq -q events,3 -q mailer,3 -q sunspot,2 -q photos,2 -q default,1 -q low,1
