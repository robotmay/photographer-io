environment     $RAILS_ENV
threads         16, 16
#daemonize       true
pidfile         "/var/run/app/web_server.pid"
state           "/var/run/app/web_server.state"
bind            "unix:///var/run/app/web_server.sock"
control         "unix:///var/run/app/web_control.sock"

# Add a worker per CPU core
workers         %x{grep -c processor /proc/cpuinfo}.strip
