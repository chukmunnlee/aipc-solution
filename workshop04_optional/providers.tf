terraform {
  required_version = ">= 1.0.0"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.9.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.12.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider digitalocean {
  token = var.DO_token
}

provider docker {
  host = "tcp://${var.docker_host}:${var.docker_port}"
  cert_path = var.docker_cert_path
}

provider local { }
