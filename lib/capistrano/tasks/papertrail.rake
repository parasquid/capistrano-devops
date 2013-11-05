load File.expand_path("../set_rails_env.rake", __FILE__)

namespace :papertrail do
  # desc 'Adds papertrail to rsyslog as an output channel'
  task :add_to_rsyslog do
    # as root add
    # *.*          @logs.papertrailapp.com:31378
    # to the end of /etc/rsyslog.conf

    # restart rsyslog
    # sudo /etc/init.d/rsyslog restart
  end

  # desc 'Install remote_syslog'
  task :remote_syslog do
    # sudo gem install remote_syslog
    # Paths to log file(s) can be specified on the command-line, or save log_files.yml.example (typically as /etc/log_files.yml). Edit it to define:
    #   - path to this app's log file, and any other log file(s) to watch.
    #   - destination host and port (provided by Papertrail). You can find the settings by clicking Add System from the dashboard.

    # /etc/log_files.yml
    # files:
    #   - /var/log/httpd/access_log
    #   - /var/log/httpd/error_log
    #   - /opt/misc/*.log
    #   - /var/log/mysqld.log
    #   - /var/run/mysqld/mysqld-slow.log
    # destination:
    #   host: logs.papertrailapp.com
    #   port: 12345   # NOTE: change to your Papertrail port

    # While remote_syslog does not need to run as root, it does need permission to write its PID file (by default to /var/run/remote_syslog.pid) and read permission on the log files it is monitoring.

    # remote_syslog.upstart.conf
    # description "Monitor files and send to remote syslog"
    # start on runlevel [2345]
    # stop on runlevel [!2345]

    # respawn

    # pre-start exec /usr/bin/test -e /etc/log_files.yml

    # exec /var/lib/gems/1.8/bin/remote_syslog -D --tls
  end

  desc 'Installs papertrail and adds remote_syslog'
  task :install do
  end

end