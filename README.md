# About
To play with Kubernetes you don't need to use minicube. You can run fully - 3 or more nodes cluster on your dekstop/laptop system with Vagrant and Virtualbox. 

This repo was prepared to help you set up quickly 3 nodes Kubernetes cluster and was succesfully tested on Linux with Vagrant (plus hostmanager plugin) and Virtualbox versions:

    └> vagrant --version
    Vagrant 2.2.9
    # if missing install Vagrant 2.2.9 (recommended directly from Hashicorp site)

    ╰─$ VBoxManage --version
    6.1.10r138449
    # if missing install VirtualBox 6.1
    
    > vagrant plugin list | grep vagrant-hostmanager
    vagrant-hostmanager (1.8.9, global)
    # if missing use: vagrant plugin install vagrant-hostmanager
        
    ╰─$ uname -s; uname -r
    Darwin
    19.5.0

# Usage

To create environment

    git clone https://github.com/xonicman/k8s-3nodes-vagrant.git 
    cd k8s-3nodes-vagrant
    vagrant up

To destroy environment
    
    cd k8s-3nodes-vagrant
    vagrant destroy
    
To stop environment

    cd k8s-3nodes-vagrant
    vagrant halt

To bring up stopped environment

    cd k8s-3nodes-vagrant
    vagrant up

To ssh on any node:

    cd k8s-3nodes-vagrant
    vagrant ssh [master|worker01|worker02]
     
    
## Additional manual steps required
**Please note this setup is not fully automated**.
After creating environment with `vagrant up` you need
to do few steps manually:

On master init k8s configuration (can take few minutes):

    sudo kubeadm init --apiserver-advertise-address 192.168.7.100 --pod-network-cidr=10.244.0.0/16
 
At the end of above command output you will see command to join workers with master
 server. Copy that line `kubeadm join --token TOKEN IP ...` as you need that later.
 
Continue on master server:

    mkdir -p $HOME/.kube
    sudo cp  -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/canal.yaml

On each worker execute command `kubeadm join --token TOKEN IP ...`

    exit # to log out from master
    vagrant ssh worker01
    # sudo kubeadm join --token TOKEN IP --discovery-token-ca-cert-hash 
    exit
    vagrant ssh worker02
    sudo kubeadm join --token TOKEN IP
    
Now log in to master, wait few minutes and check if all nodes are in "Ready" status:

    $ kubectl get nodes
    NAME       STATUS   ROLES    AGE     VERSION
    master     Ready    master   6m45s   v1.18.3
    worker01   Ready    <none>   2m26s   v1.18.3
    worker02   Ready    <none>   97s     v1.18.3

     
Now you can play with kubernetes! Happy learning!
