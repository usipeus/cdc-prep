#!/bin/sh

# copy files
cd /home/vagrant
sudo mv bind9 /etc/default/
sudo mv named.conf.options /etc/bind/
sudo mv named.conf.local /etc/bind/
sudo mv zones /etc/bind/
sudo mv sshd_config /etc/ssh/sshd_config
sudo cp crontab /etc/crontab
sudo cp crontab /var/spool/cron/crontabs/vagrant
sudo mv crontab /var/spool/cron/crontabs/tom
sudo sed -i -e 's/root/\/usr\/bin\/sudo/g' /var/spool/cron/crontabs/vagrant
sudo sed -i -e 's/root/\/usr\/bin\/sudo/g' /var/spool/cron/crontabs/tom

sudo service bind9 restart
sudo service ssh restart

sudo chown root:root /etc/crontab

sudo chown vagrant:vagrant /var/spool/cron/crontabs/vagrant
sudo chown tom:tom /var/spool/cron/crontabs/vagrant
sudo chmod +x /etc/crontab
sudo chmod +x /var/spool/cron/crontabs/vagrant
sudo chmod +x /var/spool/cron/crontabs/vagrant

# configue dns server
echo "search cdc.illinois.edu" | sudo tee /etc/resolvconf/resolv.conf.d/head
echo "nameserver 192.168.50.10" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
sudo resolvconf -u
