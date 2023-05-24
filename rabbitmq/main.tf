terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-rabbitmq" {
    name = "rabbitmq:3.11-management"
}

resource "docker_network" "rabbitmq" {
  name   = "rabbitmq"
  driver = "bridge"
}

resource "docker_image" "img-prometheus" {
    name = "prom/prometheus"
}

resource "docker_image" "img-grafana" {
    name = "grafana/grafana"
}

resource "docker_container" "rabbitmq-1" {
    name     = "rabbitmq-1"
    image    = docker_image.img-rabbitmq.image_id
    hostname = "rabbitmq-1"

    ports {
        internal = 15672
        external = 8081
    }

    ports {
        internal = 5672
        external = 30169
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        container_path  = "/config/"
        host_path       = "${path.cwd}/rabbitmq/node-1/"
        read_only       = false
    }

    env = [
    "RABBITMQ_CONFIG_FILE=/config/rabbitmq",
    "RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP"
    ]

    restart   = "on-failure"

}

resource "docker_container" "rabbitmq-2" {
    name     = "rabbitmq-2"
    image    = docker_image.img-rabbitmq.image_id
    hostname = "rabbitmq-2"

    ports {
        internal = 15672
        external = 8082
    }

    ports {
        internal = 5672
        external = 30269
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        container_path  = "/config/"
        host_path       = "${path.cwd}/rabbitmq/node-2/"
        read_only       = false
    }

    env = [
    "RABBITMQ_CONFIG_FILE=/config/rabbitmq",
    "RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP"
    ]

    restart   = "on-failure"

}

resource "docker_container" "rabbitmq-3" {
    name     = "rabbitmq-3"
    image    = docker_image.img-rabbitmq.image_id
    hostname = "rabbitmq-3"

    ports {
        internal = 15672
        external = 8083
    }

    ports {
        internal = 5672
        external = 30369
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        container_path  = "/config/"
        host_path       = "${path.cwd}/rabbitmq/node-3/"
        read_only       = false
    }

    env = [
    "RABBITMQ_CONFIG_FILE=/config/rabbitmq",
    "RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP"
    ]

    restart   = "on-failure"

}

resource "docker_container" "prometheus" {
    name = "prometheus"
    image = docker_image.img-prometheus.image_id

    ports {
        internal = 9090
        external = 9090
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        host_path = "/vagrant/monitoring/prometheus.yml"
        container_path = "/etc/prometheus/prometheus.yml"
        read_only = true
    }

    restart = "always"

}

resource "docker_container" "grafana" {
    name = "grafana"
    image = docker_image.img-grafana.image_id

    ports {
        internal = 3000
        external = 3000
    }

    networks_advanced {
        name = "rabbitmq"
    }

    volumes {
        host_path = "/vagrant/monitoring/datasources.yml"
        container_path = "/etc/grafana/provisioning/datasources/datasource.yaml"
        read_only = true
    }

    volumes {
        host_path = "/vagrant/monitoring/dashboards"
        container_path = "/etc/dashboards"
        read_only = true
    }

    volumes {
        host_path = "/vagrant/monitoring/dashboard.yml"
        container_path = "/etc/grafana/provisioning/dashboards/dashboard.yaml"
        read_only = true
    }

    restart = "always"

}
