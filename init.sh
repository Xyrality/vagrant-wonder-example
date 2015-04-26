#!/bin/bash

echo Installing required modules...

puppet module install --target-dir modules puppetlabs-apache
puppet module install --target-dir modules puppetlabs-postgresql
puppet module install --target-dir modules saz-memcached
puppet module install --target-dir modules thomasvandoren-redis
git clone https://github.com/Xyrality/puppet-wonder-plugin.git ../vagrant-wonder/modules/wonder modules/wonder
 
echo Fetching reboot provisioner 
wget https://raw.githubusercontent.com/exratione/vagrant-provision-reboot/master/vagrant-provision-reboot-plugin.rb
