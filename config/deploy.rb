require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require "rvm/capistrano"

load 'deploy/assets'

#set up whenever
set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
require "whenever/capistrano"

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
ssh_options[:forward_agent] = true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

before "deploy:restart", "deploy:migrate"

require 'capistrano_recipes'
