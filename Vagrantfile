require './vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/trusty64"

	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--nictype1", "virtio"]
		v.memory = 4096
	end

	config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
	config.vm.network "forwarded_port", guest: 1085, host: 1085, auto_correct: true, host_ip: '127.0.0.1'
	config.vm.network "forwarded_port", guest: 1086, host: 1086, auto_correct: true, host_ip: '127.0.0.1'
	config.vm.network "forwarded_port", guest: 5432, host: 15432, auto_correct: true, host_ip: '127.0.0.1'

	config.vm.synced_folder "apps/", "/home/wouser/apps", owner: 2000, group: 2000, create: "true"
	config.vm.synced_folder "logs/", "/home/wouser/logs", owner: 2000, group: 2000, create: "true"

	config.vm.provision "shell", :inline => <<-SHELL
		export DEBIAN_FRONTEND=noninteractive
		apt-get update
		apt-get upgrade
		apt-get install -y linux-headers-virtual linux-image-extra-virtual puppet
	SHELL

	config.vm.provision :unix_reboot

	config.vm.provision "puppet" do |puppet|
		puppet.module_path = "modules"
	end
end
