terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-emit-app" {
  name         = "emit-app"
  build {
    context    = "/vagrant/topics/docker"
    dockerfile = "Dockerfile-emit"
  }
}

resource "docker_image" "img-recv-app" {
  name         = "recv-app"
  build {
    context    = "/vagrant/topics/docker"
    dockerfile = "Dockerfile-recv"
  }
}

resource "docker_container" "emit-app" {
  name  = "emit-container"
  image = docker_image.img-emit-app.image_id

  networks_advanced {
        name = "rabbitmq"
    }

    restart   = "on-failure"

}

resource "docker_container" "recv-app" {
  name  = "recv-container"
  image = docker_image.img-recv-app.image_id

  networks_advanced {
        name = "rabbitmq"
    }

    restart   = "on-failure"

}