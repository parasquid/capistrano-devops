set :unicron_user, ->{ fetch(:user) }
set :unicron_pid, ->{ "#{current_path}/tmp/pids/unicron.pid" }
set :unicron_config, ->{ "#{shared_path}/config/unicron.rb" }
set :unicron_log, ->{ "#{shared_path}/log/unicron.log" }
set :unicron_workers, 8
set :unicron_timeout, 30
set :unicron_force_ssl, true

namespace :unicron do
  desc "Setup unicron initializer and app configuration"
  task :setup do
    on roles :app do
      execute :mkdir, "-p #{shared_path}/config"

      template "unicron_init.erb", "/tmp/unicron_init"
      template 'unicron.erb', "#{fetch(:unicron_config)}"

      execute :chmod, "+x /tmp/unicron_init"
      as(:root) do
        execute :mv, "/tmp/unicron_init /etc/init.d/unicron_#{fetch(:application)}"
        execute :'update-rc.d', "-f unicron_#{fetch(:application)} defaults"
      end
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicron"
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        command_string = "unicron_#{fetch(:application)} #{command}"
        execute :service, command_string
      end
    end
  end
end
