#!/bin/sh
cd ~
yum update -y
yum install openssl -y

mkdir .ssh
cd ~/.ssh
wget -N --no-check-certificate https://github.com/johnpoint/start-vps-shell/blob/master/authorized_keys
chmod 600 authorized_keys
chmod 700 ~/.ssh

cd /etc/ssh
rm -rf /etc/ssh/sshd_config

echo 'wget -N --no-check-certificate https://github.com/johnpoint/start-vps-shell/blob/master/sshd_config'
echo 'service sshd restart'

end
