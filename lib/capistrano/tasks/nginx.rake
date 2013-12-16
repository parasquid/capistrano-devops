set :server_name, ->{ fetch(:application) }

namespace :nginx do
  namespace :rainbows do
    desc "Setup nginx configuration for this application (rainbows)"
    task :setup
      on roles: :web do
        template "nginx_rainbows.erb", "/tmp/nginx_conf"

        as :root do
          execute :mv "/tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
          execute :rm "-f /etc/nginx/sites-enabled/default"
        end
      end
    end
    after 'nginx_rainbows:setup', 'nginx:restart'
  end
end
