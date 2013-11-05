set :rainbows_user, ->{ fetch(user) }
set :rainbows_pid, ->{ "#{current_path}/tmp/pids/rainbows.pid" }
set :rainbows_config, ->{ "#{shared_path}/config/rainbows.rb" }
set :rainbows_log, ->{ "#{shared_path}/log/rainbows.log" }
set :rainbows_workers, 2

namespace :rainbows do
  desc "Setup Rainbows initializer and app configuration"
  task :setup do
    on roles :app do
      run "mkdir -p #{fetch(:shared_path)}/config"
      template "rainbows.erb", rainbows_config
      template "rainbows_init.erb", "/tmp/rainbows_init"
      run "chmod +x /tmp/rainbows_init"
      run "#{sudo} mv /tmp/rainbows_init /etc/init.d/rainbows_#{fetch(:application)}"
      run "#{sudo} update-rc.d -f rainbows_#{fetch(:application)} defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} rainbows"
    task command do
      on roles :app do
        command_string = "rainbows_#{fetch(:application)} #{command}"
        execute :service, command_string
      end
    end
  end
end