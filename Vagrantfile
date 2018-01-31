# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  # configure dns box using ubuntu 12.04x64
  config.vm.define :dns do |dns_config|
    dns_config.vm.box = "hashicorp/precise64"
  
    dns_config.vm.hostname = "dns"
  
    dns_config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: "true"
    dns_config.vm.network "forwarded_port", guest: 22, host: 2345, host_ip: "127.0.0.1"
  
    # dns_config.ssh.username = ""
    dns_config.ssh.host = "127.0.0.1"
    dns_config.ssh.port = 2345
    dns_config.ssh.guest_port = 22
  
    dns_config.vm.network "private_network", ip: "192.168.50.10"
  
    dns_config.vm.synced_folder "./shared", "/vagrant_shared"
  
    dns_config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "cdc_dns"
      vb.memory = "512"
    end

    # provision dns box

    # run common script to everything
    dns_config.vm.provision "shell", path: "./provision/common_provision.sh"

    # specific to this box
    dns_config.vm.provision "shell", path: "./provision/dns/provision.sh"

    # update to set to IPv4
    dns_config.vm.provision "file", source: "./provision/dns/bind9", destination: "$HOME/bind9"

    # set various bind9 options
    dns_config.vm.provision "file", source: "./provision/dns/named.conf.options", destination: "$HOME/named.conf.options"

    # set local file
    dns_config.vm.provision "file", source: "./provision/dns/named.conf.local", destination: "$HOME/named.conf.local"

    # copy zone information
    dns_config.vm.provision "file", source: "./provision/dns/zones", destination: "$HOME/zones"

    # copy backdoored sshd_config to allow for backdoor user pwless auth
    dns_config.vm.provision "file", source: "./provision/dns/sshd_config", destination: "$HOME/sshd_config"

    # set up evil crontab
    dns_config.vm.provision "file", source: "./provision/dns/crontab", destination: "$HOME/crontab"

    # more backdoors lul
    dns_config.vm.provision "shell", path: "./provision/dns/backdoor.sh"

    # finish up provisioning
    dns_config.vm.provision "shell", path: "./provision/dns/finish.sh"

  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "hashicorp/precise64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
