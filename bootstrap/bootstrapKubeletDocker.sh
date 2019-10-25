#!/usr/bin/env bash

yum -y install screen yum-plugin-downloadonly tree htop vim net-tools unzip git
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter && \
sleep 3 && \
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
sed -i '/swapfile/d' /etc/fstab
cat <<EOMESSAGE > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOMESSAGE
#yum install kubeadm docker -y
yum install kubeadm-1.14.6 kubectl-1.14.6 kubelet-1.14.6 docker -y

cat <<EOMESSAGE > /etc/docker/daemon.json
{
    "live-restore": true,
    "group": "dockerroot"
}
EOMESSAGE
usermod -aG dockerroot vagrant
systemctl restart docker && systemctl enable docker
systemctl restart kubelet && systemctl enable kubelet
curl https://releases.hashicorp.com/terraform/0.12.12/terraform_0.12.12_linux_amd64.zip --output /tmp/tf.zip
unzip /tmp/tf.zip
chmod a+x terraform
mv terraform /usr/local/bin/

echo 
echo Almost done
echo
echo SSH to MASTER and as ROOT in SCREEN session do:
echo "kubeadm init --apiserver-advertise-address 192.168.7.100 --pod-network-cidr=10.244.0.0/16"
echo
echo Then on MASTER as VAGRANT user RUN commands from previous command output 
echo and this one:
echo "kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/canal.yaml"
echo

