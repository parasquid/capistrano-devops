set :rainbows_user, ->{ fetch(:user) }
set :rainbows_pid, ->{ "#{current_path}/tmp/pids/rainbows.pid" }
set :rainbows_config, ->{ "#{shared_path}/config/rainbows.rb" }
set :rainbows_log, ->{ "#{shared_path}/log/rainbows.log" }
set :rainbows_workers, 2
set :rainbows_timeout, 30
set :rainbows_max_body_size, 1*1024*1024

namespace :rainbows do
  desc "Setup Rainbows initializer and app configuration"
  task :setup do
    on roles :app do
      execute :mkdir, "-p #{shared_path}/config"

      template "rainbows_init.erb", "/tmp/rainbows_init"
      template 'rainbows.erb', "#{fetch(:rainbows_config)}"

      execute :chmod, "+x /tmp/rainbows_init"
      as(:root) do
        execute :mv, "/tmp/rainbows_init /etc/init.d/rainbows_#{fetch(:application)}"
        execute :'update-rc.d', "-f rainbows_#{fetch(:application)} defaults"
      end
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} rainbows"
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        command_string = "rainbows_#{fetch(:application)} #{command}"
        as :root do
          execute :service, command_string
        end
      end
    end
  end
end
