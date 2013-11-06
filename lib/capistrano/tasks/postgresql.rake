namespace :postgresql do
  desc "Install required libraries"
  task :install_libraries do
    on roles(:app) do |host|
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install libpq-dev"
    end
  end
end
