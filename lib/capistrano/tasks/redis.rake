namespace :redis do
  desc "Installs the Redis server"
  task :install do
    on roles :db do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install redis-server"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command do
      on roles(:db), in: :sequence, wait: 5 do
        command_string = "redis-server #{command}"
        execute :service, command_string
      end
    end
  end
end
