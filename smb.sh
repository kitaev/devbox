#!/bin/sh

alias apt-get="sudo apt-get"
alias service="sudo service"
alias mv="sudo mv"
alias cp="sudo cp"
alias mkdir="sudo mkdir"
alias chown="sudo chown"

apt-get install -y samba

mkdir -p /shared/projects
mkdir -p /shared/maven
chown -R vagrant:vagrant /shared

mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
mv smb.conf /etc/samba/smb.conf

service smbd restart
service nmbd restart
