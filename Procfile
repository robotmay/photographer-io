web: bundle exec puma -p $PORT -t 8:8
worker: bundle exec sidekiq -q events,3 -q mailer,3 -q sunspot,2 -q default,1 -q low -c 10
photos: bundle exec sidekiq -q photos
