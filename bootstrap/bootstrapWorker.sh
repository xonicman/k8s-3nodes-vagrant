#!/usr/bin/env bash

VAGRANTSHARE="/srv/vagrant"
KUBEJOIN="$VAGRANTSHARE/kubejoin.sh"

source /vagrant/bootstrap/common.sh
source $KUBEJOIN
