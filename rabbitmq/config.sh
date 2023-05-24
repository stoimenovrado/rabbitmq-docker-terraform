#!/bin/bash

echo "* Enable the rabbitmq_federation plugin ..."
sleep 40
docker container exec rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation
docker container exec rabbitmq-2 rabbitmq-plugins enable rabbitmq_federation
docker container exec rabbitmq-3 rabbitmq-plugins enable rabbitmq_federation

echo "* Configure HA policy ..."
sleep 10
docker container exec rabbitmq-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbitmq-1","rabbit@rabbitmq-2","rabbit@rabbitmq-3"]}' --priority 1 --apply-to queues

echo "* Install Python and pika ..."
apt-get install -y python pip
update-alternatives --config python
python3 -m pip install pika --upgrade
python3 -m pip install python-daemon

echo "* Get the topics to execute ..."
cd /home/vagrant
cp -r /vagrant/topics/ .

echo "* Run the topics ..."
python3 topics/recv_log_topic.py "*.warn" "*.crit"
python3 topics/recv_log_topic.py "ram.*"
python3 topics/emit_log_topic.py