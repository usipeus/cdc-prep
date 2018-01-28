#!/bin/sh

# create new user with no password
sudo useradd tom
sudo usermod -aG sudo,admin,adm tom
echo "tom ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo passwd -d tom
