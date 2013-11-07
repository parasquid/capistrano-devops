load File.expand_path("../set_rails_env.rake", __FILE__)

namespace :ssh do
  desc 'Adds public key to the authorized_keys file (to enable passwordless login)'
  task :add_key do
    ask(:key, 'SSH public key')
    on roles(:all) do |host|
      # this script depends on the HOME environment variable to be set
      home = capture("env | grep HOME").split('=').last
      within home do
        remote_keys = capture(:cat, '.ssh/authorized_keys')
        keys = remote_keys.split("\n")
        keys << fetch(:key) + "\n"
        new_keys = StringIO.new(keys.join("\n"))
        upload! new_keys, '.ssh/authorized_keys'
      end
    end
  end
end
