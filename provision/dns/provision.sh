#!/bin/sh

# hold back grub-pc to make sure provisioning finishes
echo "grub-pc-bin hold" | sudo dpkg --set-selections
echo "grub-pc hold" | sudo dpkg --set-selections

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install bind9 bind9utils bind9-doc -y
