#!/usr/bin/env bash

MASTER_IP="192.168.7.100"
export VAGRANTSHARE="/srv/vagrant"
KUBEJOIN="$VAGRANTSHARE/kubejoin.sh"
KUBEINITLOG="/root/kubeinit.log"
VHOME="/home/vagrant"

source /vagrant/bootstrap/common.sh

echo "Kubernetes initialization (can take few minutes)..."
kubeadm init --apiserver-advertise-address $MASTER_IP --pod-network-cidr=10.244.0.0/16 > $KUBEINITLOG

grep "kubeadm join" -A1 $KUBEINITLOG > $KUBEJOIN
mkdir -p $VHOME/.kube
cp -n /etc/kubernetes/admin.conf $VHOME/.kube/config
chown -R vagrant.vagrant $VHOME/.kube
mkdir /root/.kube
cp -n /etc/kubernetes/admin.conf /root/.kube/config
cp -n /etc/kubernetes/admin.conf $VAGRANTSHARE/k8s-config

kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

