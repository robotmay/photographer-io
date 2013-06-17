environment     $RAILS_ENV
threads         16, 16
daemonize       true
pidfile         "/var/run/app/web_server.pid"
bind            "unix:///var/run/app/web_server.sock"

# Add a worker per CPU core
workers         %x{grep -c processor /proc/cpuinfo}.strip
