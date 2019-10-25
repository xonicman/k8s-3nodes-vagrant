# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.gui = false
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "master" do |master|
	  master.vm.network "private_network", ip: "192.168.7.100"
	  master.vm.hostname = "master"
 	  master.vm.provision :shell, path: "bootstrap/bootstrapKubeletDocker.sh"
  end

  config.vm.define "worker01" do |worker01|
	  worker01.vm.network "private_network", ip: "192.168.7.101"
	  worker01.vm.hostname = "worker01"
 	  worker01.vm.provision :shell, path: "bootstrap/bootstrapKubeletDocker.sh"
  end

  config.vm.define "worker02" do |worker02|
	  worker02.vm.network "private_network", ip: "192.168.7.102"
	  worker02.vm.hostname = "worker02"
 	  worker02.vm.provision :shell, path: "bootstrap/bootstrapKubeletDocker.sh"
  end

end
