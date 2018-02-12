#!/bin/bash

echo “export PROMPT_COMMAND=’history -a’” >> /etc/bash.bashrc
echo “export HISTTIMEFORMAT=’%d.%m.%y %T’” >> /etc/bash.bashrc

# change passwords
echo "Changing root pw..."
passwd root
echo "Changing administrator pw..."
passwd administrator
echo "Changing adam pw..."
passwd adam

# change home directory
# usermod -m -d /home/username username
# change user's username
# usermod -l newname oldname

# change login shells
# echo "Removing adam login shell..."
# usermod -s /bin/false adam

# lock /etc/passwd
# echo "Locking /etc/passwd..."
# chattr +i /etc/passwd

# stop unnecessary services
echo "Stopping unnecessary services: apache2, nfs-kernel-server, mysql, portmap"
# /etc/init.d/ssh stop
/etc/init.d/apache2 stop
/etc/init.d/nfs-kernel-server stop
/etc/init.d/mysql stop
/etc/init.d/portmap stop

# update /etc/apt/sources.list
echo "Updating /etc/apt/sources.list..."
sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
apt-get update

# fix nessus stuff

# fix everything
# apt-get dist-upgrade -y --force-yes
# critical and high
apt-get install curl linux-image-2.6.24-32-server php5 libkrb53 mysql-client \
	mysql-common mysql-server mysql-server-5.0 \
	bind9 bind9-doc bind9-host libbind9-30 libdns36 curl openssl \
	apt gnupg dhcp3-client dhcp3-common libcurl3 libcurl3-gnutls libssl0.9.8 \
	perl sudo openssh-client openssh-server -y --force-yes
# medium and under: just do dist-upgrade

# useful things:
# dpkg -l | grep <pkg name>
# apt-cache search <pkg name>

# run rootkit hunter
echo "Running rkhunter..."
apt-get install rkhunter -y --force-yes # 2 mb
rkhunter --update # ~5 sec
rkhunter --check # ~50 sec
less /var/log/rkhunter.log

# run clamscan
# apt-get install clamav # 5.7 mb
# freshclam # takes fucking forever, ~4-6 mins
# clamscan -r /

# check bash history log files
# tail -f /home/<user>/.bash_history
# less /var/log/faillog
# less /var/log/auth.log

# check crontab, comment out reverse shell
echo "Checking crontab..."
EDITOR=vim crontab -e
crontab -l

echo "Rebooting..."
reboot

