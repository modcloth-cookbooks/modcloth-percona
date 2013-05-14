#
# Cookbook Name:: percona
# Recipe:: backups
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Setup regularly scheduled backups (occuring at midnight PDT), and logging output to a temporary file

cron 'Percona Innobackup' do
  hour '8'
  minute '0'
  command '/tmp/percona_backup.sh 2>&1 > /tmp/db_backup.log'
end
