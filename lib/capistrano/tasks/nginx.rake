set :server_name, ->{ fetch(:application) }
set :nginx_proxy_read_timeout, '60s'

namespace :nginx do
  desc "Installs nginx on all app servers"
  task :install do
    on roles(:app) do |host|
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nginx"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles :app do
        as :root do
          execute :service, "nginx #{command}"
        end
      end
    end
  end
end

namespace :nginx do
  namespace :rainbows do
    desc "Setup nginx configuration for this application (rainbows)"
    task :setup do
      on roles :web do
        template "nginx_rainbows.erb", "/tmp/nginx_conf"

        as :root do
          execute :mv, "/tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
          execute :rm, "-f /etc/nginx/sites-enabled/default"
        end
      end
      after 'nginx:rainbows:setup', 'nginx:restart'
    end
  end

  namespace :unicorn do
    desc "Setup nginx configuration for this application (unicorn)"
    task :setup do
      on roles :web do
        if fetch(:unicorn_force_ssl) == true
          template "nginx_unicorn_ssl.erb", "/tmp/nginx_conf"
        else
          template "nginx_unicorn.erb", "/tmp/nginx_conf"
        end

        as :root do
          execute :mv, "/tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
          execute :rm, "-f /etc/nginx/sites-enabled/default"
        end
      end
      after 'nginx:unicorn:setup', 'nginx:restart'
    end
  end
end
