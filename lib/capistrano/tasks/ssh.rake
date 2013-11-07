namespace :ssh do
  desc 'Adds public key to the authorized_keys file (to enable passwordless login)'
  task :add_key do
    ask(:key, 'SSH public key')
    on roles(:all) do |host|
      remote_keys = capture(:cat, '~/.ssh/authorized_keys')
      info remote_keys
    end
  end
end
