terraform {
  required_version = ">1.0.0"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_token
}
