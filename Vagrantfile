# -*- mode: ruby -*-
# vi: set ft=ruby :

# We recommend developing GitLab on metal if you can.
# Vagrant can be very slow since the NFS server is on the host OS.
# And GitLab (testing) accesses a lot of files.
# You can improve the speed by running NFS on the guest OS.
# In this case you should take care to not lose the files.

VAGRANTFILE_API_VERSION = "2"

$apt_reqs = <<EOT
apt-get -y install git g++ pkg-config
apt-get -y install postgresql libpq-dev phantomjs redis-server libicu-dev cmake
EOT

# CentOS 6 kernel doesn't suppose UID mapping (affects vagrant-lxc mostly).
$user_setup = <<EOT
if [ $(id -u vagrant) != $(stat -c %u /vagrant) ]; then
	useradd -u $(stat -c %u /vagrant) -m build
	echo "build ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/build
	DEV_USER=build
else
	DEV_USER=vagrant
fi
sudo -u $DEV_USER -i bash -c "curl -sSL https://get.rvm.io | bash -s stable --ruby"
EOT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.provision "shell", inline: $apt_reqs
	config.vm.provision "shell", inline: $user_setup

	config.vm.network "forwarded_port", guest: 3000, host: 3000

	config.vm.provider "lxc" do |v, override|
		override.vm.box = "fgrehm/trusty64-lxc"
	end
	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--memory", "2048"]
	end
end
