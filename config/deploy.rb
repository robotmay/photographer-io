require 'bundler/capistrano'
require 'capistrano/foreman'
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

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

set :bundle_without, [:development, :test, :acceptance]

set :foreman_sudo, 'sudo'
set :foreman_upstart_path, '/etc/init'
set :foreman_options, {
  app: application,
  log: "#{shared_path}/log",
  user: user
}

set :default_environment, {
  
}

role :web
role :app
role :db

server "pio-web-1", :web, :app, :db, primary: true
#server "pio-web-2", :web, :app

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
#

namespace :deploy do
  task :restart, roles: :app, except: { no_release: true } do
    foreman.export
    foreman.restart
  end
end

before 'dotenv:symlink', :upload_env_vars
task :upload_env_vars do
  upload(".env.#{rails_env}", "#{shared_path}/.env", :via => :scp)
end
