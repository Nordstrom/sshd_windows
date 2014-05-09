#
# Author:: Peter Dalinis (<peter.dalinis@nordstrom.com>>)
# Cookbook Name:: ssh_windows
# Attribute:: default
#
# Copyright 2014, Nordstrom, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# assumes that chef-vault gem is installed.
require 'chef-vault'
require 'socket'

::Chef::Resource::PowershellScript.send(:include, Chef::Mixin::PowershellOut)

install_path = node[:ssh_windows][:install_path]
user_vault_item = ChefVault::Item.load(node[:ssh_windows][:user_vault], node[:ssh_windows][:user_vault_item])
user = node[:ssh_windows][:user]
package_name = node[:ssh_windows][:package_name]
ssh_dir = "#{install_path}\\home\\#{user}\\.ssh"

# This can be removed when the package maintaner adds the version to the nsis installer.
windows_package 'Remove old version of OpenSSH' do
  package_name package_name
  action :remove
  installer_type :nsis
  not_if {
    `"#{install_path}\\bin\\ssh.exe" -V 2>&1` =~ /#{node[:ssh_windows][:ssh_version]}/
  }
end

windows_package 'Install OpenSSH' do
  package_name package_name
  action :install
  source node[:ssh_windows][:location]
  checksum node[:ssh_windows][:checksum]
  options "/port=#{node[:ssh_windows][:port]} /domain=#{node[:ssh_windows][:domain]} /S"
  installer_type :nsis
end

template "#{install_path}\\etc\\sshd_config" do
  source 'sshd_config.erb'
  notifies :restart, 'service[OpenSSHd]', :delayed
end

# create the authorized_keys file and directory structure for the specified user.
directory ssh_dir do
  action :create
end

file "#{ssh_dir}\\authorized_keys" do
  content user_vault_item[node[:ssh_windows][:user_vault_rsa_key_value]]
  notifies :restart, 'service[OpenSSHd]', :delayed
end

# sshd doesnt work when used with cert only auth unless its run under the account :(
# it would be nice to figure out why and remove this.

# install ntrights.exe
cookbook_file "#{Chef::Config[:file_cache_path]}\\ntrights.exe" do
  source 'ntrights.exe'
end

# upgrade privs
powershell_script 'Upgrade user priviliges to logon as service' do
  code "#{Chef::Config[:file_cache_path]}\\ntrights.exe -u #{user} +r SeServiceLogonRight"
end

sshd_service = "Get-WmiObject win32_service | where Name -eq \'OpenSSHd\'"

powershell_script 'Set OpenSSHd service credentials' do
  code <<-EOH
    $svc = #{sshd_service}
    $svc.Change($null,$null,16,$null,$null,$null,'#{Socket.gethostname}\\#{user}','#{user_vault_item[node[:ssh_windows][:user_vault_password_value]]}')
  EOH
  only_if {
    running_as = powershell_out("return (#{sshd_service}).StartName").stdout.chop
    "#{user}" != running_as
  }
  notifies :restart, 'service[OpenSSHd]', :delayed
end

# for restart events
service 'OpenSSHd' do
  action :nothing
end
