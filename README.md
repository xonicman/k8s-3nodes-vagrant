# About
To play with Kubernetes you don't need to use minicube. You can run fully - 3 or more nodes cluster on your dekstop/laptop system with Vagrant and Virtualbox. 

This repo was prepared to help you set up quickly 3 nodes Kubernetes cluster and was succesfully tested on Linux with Vagrant and Virtualbox versions:

    └> vagrant --version
    Vagrant 2.2.5

    └> vboxmanage --version
    6.0.12r132055
        
    └> uname -s; uname -r
    Linux
    5.3.0-arch1-1-ARCH

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
     
    
## Additional manaul steps required
**Please note this setup is not fully automated**.
After creating environment with `vagrant up` you need
to do few steps manually:

Ssh to master and init k8s configuration:

    cd k8s-3nodes-vagrant
    vagrant ssh master
    sudo su -
    whoami #make sure you are working as root
    kubeadm init --apiserver-advertise-address 192.168.7.100 --pod-network-cidr=10.244.0.0/16
 
At the end of above command you will see command line that should be used 
 on all worker nodes to join cluster. Please note that command. It should 
 something like `kubeadm join --token TOKEN IP` - you will use that command later.
 
Now prepare configuration for `vagrant` user on master server - you
will control k8s via this user:

    exit #to log out from root
    whoami #to make sure you are logged as vagrant user
    mkdir -p $HOME/.kube
    sudo cp  -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
Now set up k8s networking as vagrant user:

    whoami #to make sure you are logged as vagrant
    kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/canal.yaml

Next ssh to each worker and run command that you noted in previous steps to join workers into cluster

    exit # to log out from master
    vagrant ssh worker01
    kubeadm join --token TOKEN IP
    exit
    vagrant ssh worker02
    kubeadm join --token TOKEN IP
    
Now log in to master, wait few minutes and check if all nodes are in "Ready" status:

    exit # to log out from worker02
    vagrant ssh master
    kubectl get nodes #should give output
    NAME       STATUS   ROLES    AGE   VERSION
    master     Ready    master   22d   v1.14.6
    worker01   Ready    <none>   22d   v1.14.6
    worker02   Ready    <none>   22d   v1.14.6

     
Now you can play with kubernetes! Happy learning!
     
# Extra info
 
## Terraform installed as well
Because kubernetes cluster and pods are very often deployed via terraform, it was also added to bootstrap script. 

## Usefull links
* https://www.linuxtechi.com/install-kubernetes-1-7-centos7-rhel7/
