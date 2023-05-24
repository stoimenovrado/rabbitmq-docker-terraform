#!/bin/bash

echo "* Download and extract the node exporter package ..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz

echo "* Start the node exporter ..."
cd node_exporter-1.5.0.linux-amd64/
./node_exporter &> /tmp/node-exporter.log &
