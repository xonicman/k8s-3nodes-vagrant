#!/usr/bin/env bash


# Requirements & usefull tools

yum -y install \
  screen \
  yum-plugin-downloadonly \
  tree \
  htop \
  vim \
  net-tools \
  unzip \
  git \
  nfs-utils \
  zsh \
  yum-utils \
  device-mapper-persistent-data \
  lvm2

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter && \
sleep 3 && \
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
echo '1' > /proc/sys/net/bridge/bridge-nf-call-ip6tables

swapoff -a
sed -i '/swapfile/d' /etc/fstab


# Docker

yum-config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

yum install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli

mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
usermod -aG docker vagrant


# Kubernetes

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

#install newest version
yum install kubeadm kubectl kubelet --disableexcludes=kubernetes -y

systemctl enable --now kubelet

echo 'alias k=kubectl' >  /etc/profile.d/k8s.sh


# ZSH

chsh -s /bin/zsh root
chsh -s /bin/zsh vagrant

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc

sed -i 's/^ZSH_THEME.*/ZSH_THEME="bira"/g' /root/.zshrc

cat <<EOT >> /root/.zshrc

source <(kubectl completion zsh)

export dr='--dry-run=client'
export oy='-o yaml'
export dry='--dry-run=client -o yaml'
export gpf='--grace-period=0 --force'

EOT

rsync -a /root/.oh-my-zsh /home/vagrant/
chown vagrant.vagrant  -R /home/vagrant/.oh-my-zsh

cp /root/.zshrc /home/vagrant/.zshrc
chown vagrant.vagrant /home/vagrant/.zshrc

# /ZSH


cat <<EOT >> /etc/vimrc

set expandtab
set tabstop=2
set shiftwidth=2
set autoindent

EOT


# Other

ln -s $VAGRANTSHARE /home/vagrant/share

