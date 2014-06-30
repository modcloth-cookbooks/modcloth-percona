#
# Cookbook Name:: percona
# Recipe:: backups
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Setup regularly scheduled backups (occuring at midnight PDT), and logging output to a temporary file

schedule = node[:percona][:backup][:crontab_schedule]

cron 'Percona Innobackup' do
  minute schedule[0]
  hour schedule[1]
  day schedule[2]
  month schedule[3]
  weekday schedule[4]
  command '/opt/local/bin/percona_backup.sh 2>&1 > /tmp/db_backup.log'
end
