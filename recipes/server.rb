#
# Cookbook Name:: percona
# Recipe:: server
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

execute "install percona-server" do
   command "pkgin -y in percona-server-"+"#{node[:percona][:version]}" 
   returns [0,1]
end

package "percona-toolkit" do
   action :install
end

execute "install xtrabackup" do
   command "pkgin -y in percona56-xtrabackup"
   only_if { node[:percona][:version] == '5.6' }
   returns [0,1]
end

execute "percona55-xtrabackup" do
   command "pkgin -y in percona55-xtrabackup"
   only_if { node[:percona][:version] == '5.5' }
   returns [0,1]
end

template '/opt/local/etc/my.cnf' do
  source 'my.cnf.erb'
  mode '0644'
end

# Linking the 'default' location of the my.cnf to the location that the rest of the world expects it

link '/etc/my.cnf' do
  to '/opt/local/etc/my.cnf'
end

# Linking the data dir to make the transition from legacy stuff easier...

link '/databases' do
  to '/var/mysql'
end

cookbook_file '/opt/local/bin/percona_restore.sh' do
  source 'percona_restore.sh'
  mode '0755'
end

template '/opt/local/bin/percona_backup.sh' do
  source 'percona_backup.sh.erb'
  mode '0755'
end

# This stuff resets the root password if needed

cookbook_file '/opt/local/bin/percona-reset-root-password.sh' do
  source 'reset-root-password.sh'
  mode 0700
end

bash 'set blank root password for mysql' do
  user 'root'
  code '/opt/local/bin/percona-reset-root-password.sh'
  not_if { ::File.exists?('/root/.my.cnf') }
end

# This stuff is needed universally by the BI team for timezone conversions in their reports

execute "add timezone tables to mysql" do
  command "/opt/local/bin/mysql_tzinfo_to_sql /usr/share/lib/zoneinfo | mysql -u root mysql"
  only_if "mysql -e \"show databases;\" | grep mysql"
  not_if "mysql -e \"select * from mysql.time_zone;\" | grep leap_seconds"
end

