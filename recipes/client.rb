#
# Cookbook Name:: percona
# Recipe:: client
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

package "mysql-client-" + "#{node[:percona][:version]}" do
 action :install
end
