#!/bin/sh
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_INSTALLED_VERSION=$(lsmod | grep -io vboxguest | xargs modinfo | grep -iw version | awk '{print $2}')

echo "Installed GA version $VBOX_INSTALLED_VERSION"
echo "Latest GA version $VBOX_VERSION"

if [ "$VBOX_VERSION" = "$VBOX_INSTALLED_VERSION" ]; then
    echo "GA already installed, version $VBOX_INSTALLED_VERSION"
    exit 0;
fi

cd /tmp
wget --quiet http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso