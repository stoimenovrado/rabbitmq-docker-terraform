# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  config.vm.box = "shekeriev/debian-11"

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.memory = 4096
    v.cpus = 4
  end

  # Docker Machine - Debian 11
  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.network "private_network", ip: "192.168.89.170"
    docker.vm.provision "shell", path: "docker-terraform-setup.sh"
    docker.vm.provision "shell", path: "monitoring/node-exporter.sh"
    docker.vm.provision "shell", path: "rabbitmq/rabbitmq-up.sh"
    docker.vm.provision "shell", path: "rabbitmq/config.sh"
    docker.vm.provision "shell", path: "topics/docker/topics-docker.sh"
  end

end
