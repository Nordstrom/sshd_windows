#
# Author:: Peter Dalinis (<peter.dalinis@nordstrom.com>>)
# Cookbook Name:: windows
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

# TODO: Add x86

# ssh -V version
default[:ssh_windows][:ssh_version] = '6.6p1'
# additional version data from package maintainer
default[:ssh_windows][:version] = "#{default[:ssh_windows][:ssh_version]}-1-v1"
default[:ssh_windows][:bits] = 'x64'
default[:ssh_windows][:installer] = "setupssh-#{default[:ssh_windows][:version]}(#{default[:ssh_windows][:bits]}).exe"
default[:ssh_windows][:location] = "http://www.mls-software.com/files/#{default[:ssh_windows][:installer]}"
default[:ssh_windows][:checksum] = '5b2de27a113f'
# the name of the package, from add/remove programs, when it is installed.
default[:ssh_windows][:package_name] = 'OpenSSH for Windows (remove only)'
# the install location
default[:ssh_windows][:install_path] = 'c:\Program Files\OpenSSH'

# port to listen to
default[:ssh_windows][:port] = '22'
# use domain users (1) vs local (0)
default[:ssh_windows][:domain] = '0'

# the user to run the service as, in addition to the user to install the authorized_keys file.
default[:ssh_windows][:user] = 'Administrator'

# databag vault to use
default[:ssh_windows][:user_vault] = 'passwords'
# data bag item to use
default[:ssh_windows][:user_vault_item] = 'your_user'
# the chef-vault value that is the public key that will be used in the authorized_keys file.
default[:ssh_windows][:user_vault_rsa_key_value] = 'id_rsa.pub'
# the chef-vault value that is the password for the default[:ssh_windows][:user] account.
default[:ssh_windows][:user_vault_password_value] = 'password'
