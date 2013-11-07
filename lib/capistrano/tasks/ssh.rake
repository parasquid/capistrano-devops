namespace :ssh do
  desc 'Adds public key to the authorized_keys file (to enable passwordless login)'
  task :add_key do
    on roles(:all)
  end
end
