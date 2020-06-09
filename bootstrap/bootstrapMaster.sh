#!/usr/bin/env bash

KUBEJOIN="/srv/k8s/kubejoin.sh"
KUBEINITLOG="/root/kubeinit.log"
VHOME="/home/vagrant"

source /vagrant/bootstrap/common.sh

echo "Kubernetes initialization (can take few minutes)..."
kubeadm init --apiserver-advertise-address 192.168.7.100 --pod-network-cidr=10.244.0.0/16 > $KUBEINITLOG

grep "kubeadm join" -A1 $KUBEINITLOG > $KUBEJOIN
mkdir -p $VHOME/.kube
cp -n /etc/kubernetes/admin.conf $VHOME/.kube/config
chown -R vagrant.vagrant $VHOME/.kube
mkdir /root/.kube
cp -n /etc/kubernetes/admin.conf /root/.kube/config
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/canal.yaml
