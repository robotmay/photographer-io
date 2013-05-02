environment     $RAILS_ENV
threads         8, 16
daemonize       true
pidfile         "/tmp/web_server.pid"
bind            "unix:///tmp/web_server.sock"
stdout_redirect "#{ENV['RAILS_STACK_PATH']}/log/puma.stdout.log", "#{ENV['RAILS_STACK_PATH']}/log/puma.stderr.log"
