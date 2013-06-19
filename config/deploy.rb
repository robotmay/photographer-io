require 'bundler/capistrano'
#require 'capistrano/foreman'
require 'dotenv/capistrano'

set :application, "photographer.io"
set :repository,  "git@github.com:robotmay/iso.git"
set :scm, :git
set :branch, "production"
set :port, 7890

set :user, "deploy"
set :use_sudo, false

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/var/www/app"
set :deploy_via, :remote_cache

set :bundle_without, [:development, :test, :acceptance]

set :foreman_sudo, sudo
set :foreman_upstart_path, '/etc/init'
set :foreman_options, {
  app: "app/#{application}",
  log: "#{shared_path}/log",
  user: user
}

set :default_environment, {
  
}

set :certs_path, "#{shared_path}/certs"

role :web
role :app
role :db

server "pio-web-1", :web, :app, :db, primary: true
server "pio-web-2", :web, :app

namespace :deploy do
  task :bootstrap, roles: :app do
    deploy.setup
    deploy.update
    upload_certs
    foreman.export
    deploy.restart
    deploy.restart_nginx
  end

  task :restart_nginx, roles: :app do
    run "#{sudo} service nginx restart"
  end

  task :kill_dead_sockets, roles: :app do
    run "cd /var/run/app; #{sudo} rm web_server.sock"
  end

  task :restart, roles: :app, except: { no_release: true } do
    foreman.restart
  end
end

before 'dotenv:symlink', :upload_env_vars
task :upload_env_vars do
  upload(".env.#{rails_env}", "#{shared_path}/.env", via: :scp)
end

task :upload_certs do
  run "[ -d #{certs_path} ] || mkdir -p #{certs_path}"

  %w{bundle.pem server.crt server.key}.each do |file|
    upload("certs/#{file}", "#{certs_path}/#{file}", via: :scp)
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, roles: :app do
    cmd = "RAILS_ENV=#{rails_env} foreman"
    run "[ -d #{foreman_upstart_path} ] || #{sudo} mkdir -p #{foreman_upstart_path}"
    run "cd #{current_path} && #{cmd} export upstart #{foreman_upstart_path} #{format(foreman_options)}"
  end

  desc "Start the application services"
  task :start, roles: :app do
    run "#{sudo} service #{foreman_options[:app]} start"
  end

  desc "Stop the application services"
  task :stop, roles: :app do
    run "#{sudo} service #{foreman_options[:app]} stop"
  end

  desc "Restart the application services"
  task :restart, roles: :app do
    run "#{sudo} service #{foreman_options[:app]} start || #{sudo} service #{foreman_options[:app]}  restart"
  end

  def format(opts)
    opts.map { |opt, value| "--#{opt}=#{value}" }.join " "
  end
end
