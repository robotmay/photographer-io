require 'bundler/capistrano'
#require 'capistrano/foreman'
require 'dotenv/capistrano'
#require 'sidekiq/capistrano'

set :application, "photographer.io"
set :repository,  "git@github.com:robotmay/iso.git"
set :scm, :git
set :branch, "master"
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
    run "cd /var/run/app; rm web_server.sock"
  end

  task :start, roles: :app do
    run "#{sudo} start puma app=#{current_path}"
    run "#{sudo} start sidekiq app=#{current_path} index=0;true"
  end

  task :stop, roles: :app do
    run "#{sudo} stop puma app=#{current_path}"
    run "#{sudo} stop sidekiq app=#{current_path} index=0"
  end

  task :restart, roles: :app do
    run "#{sudo} stop puma app=#{current_path}; true && sleep 1 && rm /var/run/app/web_server.sock; true"
    deploy.start
    run "#{sudo} restart sidekiq app=#{current_path} index=0"
    #run "#{sudo} start puma app=#{current_path} || #{sudo} restart puma app=#{current_path}"
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

namespace :sake do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do
    run("cd #{deploy_to}/current && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end
