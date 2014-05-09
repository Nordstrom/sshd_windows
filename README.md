Description
===========

Upgrades/Installs and configures OpenSSHd for Windows.

The sshd server is configured for cert-based authentication only. The cookbook will install the specified certficate in the authorized_keys file of the /home/user/.ssh directory.

The user you connect with is case sensitive, so use *Administrator* instead of *administrator*.

I was not sure on the distribution rules of ntrights.exe, so make sure you put it in the files/windows directory.

See the attributes/default.rb file for notes on the required attributes.

This cookbook requires a chef-vault databag to store the certificate and password.

Platform
--------

* Windows Server 2012

Might work on others, but not tested.

ToDo
----

- When using cert-based auth, the service must run under the user you are ssh'ing into.
- There is no version data being set in the installer. The package maintainer will be adding one next release.
- Split up the cookbook to support both password auth and or cert auth.
- It currently assumes no domain.
- scp'ing files to the Windows server puts them in the OpenSSH install directory.

License and Author
==================

Author:: Peter Dalinis (<peter.dalinis@nordstrom.com>)

Copyright:: 2014, Nordstrom, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
    
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
