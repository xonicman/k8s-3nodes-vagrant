# About

To learn and play with Kubernetes you can use minicube, but with this solution you can run 3 or more nodes cluster on your dekstop/laptop system.

# Requiremets

Software: Vagrant (with vagrant-hostmanager plugin), Virtualbox
Hardware: 2GB RAM for each node (6GB for 3 nodes). At least 4 core processor.

Tested on:

    ╰─$ uname -s; uname -r
    Darwin
    19.5.0

    └> vagrant --version
    Vagrant 2.2.9
    # if missing install Vagrant 2.2.9 (recommended directly from Hashicorp site)

    ╰─$ VBoxManage --version
    6.1.10r138449
    # if missing install VirtualBox 6.1
    
    ╰─$ vagrant plugin list | grep vagrant-hostmanager
    vagrant-hostmanager (1.8.9, global)
    
        

Should work also on Linux & Windows environments with Vagrant and Virtualbox installed, but tests was not done yet for such hosts. 


# How-To

## Installation

    host$ git clone https://github.com/xonicman/k8s-3nodes-vagrant.git 
    host$ cd k8s-3nodes-vagrant
    host$ vagrant up

## Usage

    host$ cd k8s-3nodes-vagrant
    host$ vagrant ssh master
    master$ kubectl get nodes
    NAME       STATUS   ROLES    AGE     VERSION
    master     Ready    master   6m45s   v1.18.3
    worker01   Ready    <none>   2m26s   v1.18.3
    worker02   Ready    <none>   97s     v1.18.3


## Other usefull commands

### Stop environment

    cd k8s-3nodes-vagrant
    vagrant halt

### Bring up stopped environment

    cd k8s-3nodes-vagrant
    vagrant up

### ssh to any node

    cd k8s-3nodes-vagrant
    vagrant ssh [master|worker01|worker02]
     
### Recreate environment

    cd k8s-3nodes-vagrant
    vagrant destroy -f && vagrant up

### Destroy environment
    
    cd k8s-3nodes-vagrant
    vagrant destroy

## Add/remove k8s workers

Destroy environment:

    vagrant destroy

Modify Vagrantfile and add/remove worker section like this one:

    config.vm.define "workerXX" do |workerXX|
	   workerXX.vm.network "private_network", ip: "192.168.7.1XX"
	   workerXX.vm.hostname = "workerXX"
       workerXX.vm.synced_folder "tmp/", "/srv/k8s"
 	   workerXX.vm.provision :shell, path: "bootstrap/bootstrapWorker.sh"
    end

To add 3rd worker add such code:

    config.vm.define "worker03" do |worker03|
	  worker03.vm.network "private_network", ip: "192.168.7.103"
	  worker03.vm.hostname = "worker03"
      worker03.vm.synced_folder "tmp/", "/srv/k8s"
      worker03.vm.provision :shell, path: "bootstrap/bootstrapWorker.sh"
    end

Recreate environment

    vagrant up

## How to install vagrant-hostnamager plugin to Vagrant

    vagrant plugin install vagrant-hostmanager
