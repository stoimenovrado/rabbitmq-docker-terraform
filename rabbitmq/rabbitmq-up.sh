#!/bin/bash

echo "* Get the TF ..."
mkdir -p terraform
cd terraform
cp /vagrant/rabbitmq/main.tf .

echo "* Create the cluster formation config ..."
mkdir -p rabbitmq/node-{1..3}
cat <<EOF | tee rabbitmq/node-{1..3}/rabbitmq
cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-1
cluster_formation.classic_config.nodes.2 = rabbit@rabbitmq-2
cluster_formation.classic_config.nodes.3 = rabbit@rabbitmq-3
EOF

echo "* Start the cluster ..."
terraform init
terraform apply -auto-approve
