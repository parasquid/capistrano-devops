load File.expand_path("../set_rails_env.rake", __FILE__)

namespace :papertrail do
  # desc 'Adds papertrail to rsyslog as an output channel'
  task :add_to_rsyslog do
    on roles(:all) do
      as :root do
        within '/etc' do
          # TODO: this is awfully familiar to the ssh block, need to DRY up
          # TODO: instead of appending at the bottom, create a .conf in /etc/rsyslog.d/
          file = capture(:cat, 'rsyslog.conf')
          lines = file.split("\n")
          lines << "*.* @#{fetch(:papertrail_host, 'logs.papertrailapp.com')}:#{fetch(:papertrail_port, 1234)}" + "\n"
          new_file = StringIO.new(lines.join("\n"))
          upload! new_file, '/tmp/rsyslog.conf'
          execute :mv, '/tmp/rsyslog.conf', 'rsyslog.conf'
          execute :service, 'rsyslog restart'
        end
      end
    end
  end

  # desc 'Install remote_syslog on all app servers'
  task :remote_syslog do
    on roles(:app) do |host|
      as :root do
        # TODO: only install the gem if the command doesn't exist
        # maybe which remote_syslog ?
        execute :gem, 'install remote_syslog'

        LOG_FILES_YML = <<-EOF
files:
  - #{shared_path.join('log').to_s}/*.log
destination:
  host: #{fetch(:papertrail_host, 'logs.papertrailapp.com')}
  port: #{fetch(:papertrail_port, 1234)}
prepend: #{capture('hostname')} ->
hostname: #{fetch(:application)}-#{host}
EOF

        within '/etc' do
          # again, DRY this up (because as() doesn't work with upload! or within yet)
          upload! StringIO.new(LOG_FILES_YML), '/tmp/log_files.yml'
          execute :mv, '/tmp/log_files.yml', 'log_files.yml'
        end

        within '/etc/init' do

          UPSTART_CONF = <<-EOF
description "Monitor files and send to remote syslog"
start on runlevel [2345]
stop on runlevel [!2345]

respawn

pre-start exec /usr/bin/test -e /etc/log_files.yml

exec /usr/local/bin/remote_syslog -p #{fetch(:papertrail_port, 1234)} -D
EOF

# TODO: find out where the remote_syslog is (or if it even got installed)
# find / -name remote_syslog

          # again, DRY this up (because as() doesn't work with upload! or within yet)
          upload! StringIO.new(UPSTART_CONF), '/tmp/remote_syslog.conf'
          execute :mv, '/tmp/remote_syslog.conf', 'remote_syslog.conf'

        end

      end
    end
    invoke 'papertrail:restart_remote_syslog'
  end

  desc 'Restarts remote syslog'
  task :restart_remote_syslog do
    on roles(:app) do
      as :root do
        execute :service, 'remote_syslog restart'
      end
    end
  end

  desc 'Installs papertrail and adds remote_syslog'
  task :install do
    invoke 'papertrail:add_to_rsyslog'
    invoke 'papertrail:remote_syslog'
  end

end