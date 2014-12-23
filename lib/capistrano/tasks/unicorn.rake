set :unicorn_user, ->{ fetch(:user) }
set :unicorn_pid, ->{ "#{current_path}/tmp/pids/unicorn.pid" }
set :unicorn_config, ->{ "#{shared_path}/config/unicorn.rb" }
set :unicorn_log, ->{ "#{shared_path}/log/unicorn.log" }
set :unicorn_workers, 8
set :unicorn_timeout, 30
set :unicorn_force_ssl, false

namespace :unicorn do
  desc "Setup unicorn initializer and app configuration"
  task :setup do
    on roles :app do
      execute :mkdir, "-p #{shared_path}/config"

      template "unicorn_init.erb", "/tmp/unicorn_init"
      template 'unicorn.erb', "#{fetch(:unicorn_config)}"

      execute :chmod, "+x /tmp/unicorn_init"
      as(:root) do
        execute :mv, "/tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
        execute :'update-rc.d', "-f unicorn_#{fetch(:application)} defaults"
      end
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        command_string = "unicorn_#{fetch(:application)} #{command}"
        execute :service, command_string
      end
    end
  end
end
