#!/bin/sh
alias apt-get="sudo apt-get"
alias mount="sudo mount"
alias umount="sudo umount"

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
apt-get -y install build-essential linux-headers-$(uname -r)
wget --quiet http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Remove items used for building, since they aren't needed anymore
apt-get -y remove linux-headers-$(uname -r)
apt-get -y autoremove