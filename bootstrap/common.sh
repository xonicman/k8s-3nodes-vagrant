#!/usr/bin/env bash

K8S_VERSION="1.18.3"

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
  zsh
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

yum install kubeadm-$K8S_VERSION kubectl-$K8S_VERSION kubelet-$K8S_VERSION docker -y

cat <<EOMESSAGE > /etc/docker/daemon.json
{
    "live-restore": true,
    "group": "dockerroot"
}
EOMESSAGE

usermod -aG dockerroot vagrant
chsh -s /bin/zsh root
chsh -s /bin/zsh vagrant

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
rsync -a /root/.oh-my-zsh /home/vagrant/
chown vagrant.vagrant  -R /home/vagrant/.oh-my-zsh
cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc
cp /root/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chown vagrant.vagrant /home/vagrant/.zshrc
sed -i 's/^ZSH_THEME.*/ZSH_THEME="bira"/g' /root/.zshrc
sed -i 's/^ZSH_THEME.*/ZSH_THEME="bira"/g' /home/vagrant/.zshrc

systemctl restart docker && systemctl enable docker
systemctl restart kubelet && systemctl enable kubelet

echo 'alias k=kubectl' >  /etc/profile.d/k8s.sh
ln -s $VAGRANTSHARE /home/vagrant/share
