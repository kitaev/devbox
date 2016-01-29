# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false

  config.vm.hostname = "devbox"
  config.vm.network "private_network", ip: "192.168.9.10"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.provision "shell", path: "apt-update.sh"
  config.vm.provision "shell", path: "apt-install.sh"
  config.vm.provision "shell", path: "vbga.sh"

  config.vm.provision "file", source: "smb.conf", destination: "smb.conf"
  config.vm.provision "shell", path: "smb.sh"

end
