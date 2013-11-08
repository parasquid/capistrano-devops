# -*- encoding: utf-8 -*-

# https://github.com/capistrano/capistrano/issues/639
SSHKit.config.command_map[:rake] = "bundle exec rake"

set :application, 'my_app'
set :repo_url, 'https://github.com/parasquid/capistrano-devops.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/home/vagrant/www/#{fetch(:application)}"
set :subdir, 'sample_app'
set :scm, :git
set :user, 'vagrant'

set :format, :pretty
set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

  namespace :deploy do

      desc "Checkout subdirectory and delete all the other stuff"
      task :checkout_subdir do
        on roles(:app) do
          execute :mv, "#{release_path}/#{fetch(:subdir)}/ /tmp && rm -rf #{release_path}/* && mv /tmp/#{fetch(:subdir)}/* #{release_path} && rm -rf /tmp/#{fetch(:subdir)}"
        end
      end

  end

  before "deploy:symlink:shared", "deploy:checkout_subdir"

end

set :papertrail_port, 31378