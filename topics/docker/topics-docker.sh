#!/bin/bash

echo "* Get the TF ..."
cd /home/vagrant
mkdir -p topics-docker
cd topics-docker
cp /vagrant/topics/docker/main.tf .

echo "* Start the cluster ..."
terraform init
terraform apply -auto-approve
