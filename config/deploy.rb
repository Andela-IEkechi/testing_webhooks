require 'bundler/capistrano'
require 'capistrano/ext/multistage'
load 'deploy/assets'

##STAGING DEPLOYMENT IS TO HEROKU!!
set :stages, %w(production)
set :default_stage, "production"

set :application, "conductor"
set :user, "deploy"
set :group, "deploy"

set :scm, :git
set :user, "deploy"
set :use_sudo, false
set :repository, "git@github.com:Shuntyard/Conductor.git"
set :branch, "master"
set :deploy_to, "/home/deploy/rails/#{application}"
set :deploy_via, :remote_cache
set :rails_env, 'production'
#ssh_options[:forward_agent] = true


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
