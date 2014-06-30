#
# Cookbook Name:: percona
# Recipe:: client
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

# force install, because joyent can't manage a distro to save their lives
execute "install percona-client" do
   command "pkgin -y in percona-client-"+"#{node[:percona][:version]}"
   returns [0,1]
end
