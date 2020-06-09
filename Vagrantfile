# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "arfreitas/centos7-vbguest"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
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
    master.vm.synced_folder "tmp/", "/srv/k8s"
 	  master.vm.provision :shell, path: "bootstrap/bootstrapMaster.sh"
    master.vm.boot_timeout = 600
  end

  config.vm.define "worker01" do |worker01|
	  worker01.vm.network "private_network", ip: "192.168.7.101"
	  worker01.vm.hostname = "worker01"
    worker01.vm.synced_folder "tmp/", "/srv/k8s"
 	  worker01.vm.provision :shell, path: "bootstrap/bootstrapWorker.sh"
  end

  config.vm.define "worker02" do |worker02|
	  worker02.vm.network "private_network", ip: "192.168.7.102"
	  worker02.vm.hostname = "worker02"
    worker02.vm.synced_folder "tmp/", "/srv/k8s"
    worker02.vm.provision :shell, path: "bootstrap/bootstrapWorker.sh"
  end

end
