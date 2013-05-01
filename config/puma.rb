environment     $RAILS_ENV
threads         8, 16
daemonize       true
pidfile         "/tmp/web_server.pid"
bind            "unix:///tmp/web_server.sock"
stdout_redirect "#{ENV['RAILS_STACK_PATH']}/log/puma.stdout.log", "#{ENV['RAILS_STACK_PATH']}/log/puma.stderr.log"

on_restart do
  old_pid = '/tmp/web_server.pid.oldbin'
  if File.exists?(old_pid) && @options[:pid_file] != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
