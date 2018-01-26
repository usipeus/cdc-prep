#!/bin/bash

# copy files
cd /home/vagrant
sudo mv bind9 /etc/default/
sudo mv named.conf.options /etc/bind/
sudo mv named.conf.local /etc/bind/
sudo mv zones /etc/bind/

sudo service bind9 restart

# configue dns server
echo "search cdc.illinois.edu" | sudo tee /etc/resolvconf/resolv.conf.d/head
echo "nameserver 192.168.50.10" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
sudo resolvconf -u
