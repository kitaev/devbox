# -*- mode: ruby -*-
# vi: set ft=ruby :

rootFolder = "#{File.dirname(__FILE__)}"
require 'yaml'
require rootFolder + File::SEPARATOR + 'devbox' + File::SEPARATOR + 'devbox.rb'
require rootFolder + File::SEPARATOR + 'devbox' + File::SEPARATOR + 'config.rb'

settings = DevBox::Config.new [rootFolder + File::SEPARATOR + 'devbox.defaults.yaml', rootFolder + File::SEPARATOR + 'devbox.yaml']


Vagrant.configure(2) do |config|
  DevBox::VagrantConfiguration.configure(rootFolder, settings, config)

#  config.vm.box = "debian/jessie64"
#  config.vm.box_check_update = false

#  config.vm.hostname = "devbox"
#  config.vm.network "private_network", ip: "192.168.9.10"

#  config.vm.synced_folder ".", "/vagrant", disabled: true

#  config.vm.provider "virtualbox" do |vb|
#    vb.memory = "4096"
#  end

#  config.vm.provision :shell do |shell|
#    shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
#    shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
#  end
#  config.ssh.forward_agent = true

#  config.vm.provision "shell", path: "apt-update.sh"
#  config.vm.provision "shell", path: "apt-install.sh"
#  config.vm.provision "shell", path: "vbga.sh"

#  config.vm.provision "file", source: "smb.conf", destination: "smb.conf"
#  config.vm.provision "shell", path: "smb.sh"

#  config.vm.provision "shell", path: "git.sh", args: "'Alexander Kitaev' 'alexander.kitaev@tmatesoft.com'"

#  config.vm.provision "file", source: "maven-settings.xml", destination: "maven-settings.xml"
#  config.vm.provision "shell", path: "maven-settings.sh"

#  config.vm.provision "docker"

end
