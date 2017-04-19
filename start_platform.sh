#!/bin/bash

echo "Provisioning platform"

if ! [[ -d code ]];then
	mkdir code
fi

vagrant plugin list | grep vbguest

if [[ $? -ne 0 ]];then
	vagrant plugin install vagrant-vbguest
fi

vagrant up
