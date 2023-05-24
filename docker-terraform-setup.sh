#!/bin/bash

echo "* Add hostname ..."
echo "192.168.89.170 docker.hw7.lab docker" >> /etc/hosts

echo "* Add any prerequisites ..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release vim

echo "* Add Docker repository and key ..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Install Docker ..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

echo "* Adjust Docker to share metrics ..."
echo '
{
  "metrics-addr" : "192.168.89.170:9323",
  "experimental" : true
}' >> /etc/docker/daemon.json
systemctl restart docker

echo "* Download TF ... *"
wget https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip -O /tmp/terraform.zip

echo "* Unzip TF ... *"
unzip /tmp/terraform.zip

echo "* Move TF to PATH ... *"
mv terraform /usr/local/bin/

echo "* Remove TF archive ... *"
rm /tmp/terraform.zip
