#!/usr/bin/env bash

export VAGRANTSHARE="/srv/vagrant"
KUBEJOIN="$VAGRANTSHARE/kubejoin.sh"

source /vagrant/bootstrap/common.sh
source $KUBEJOIN
