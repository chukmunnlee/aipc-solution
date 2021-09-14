variable DO_TOKEN {
  type = string
  sensitive = true
  default = env("DIGITALOCEAN_TOKEN")
}

variable DO_region {
  type = string
  default = "sgp1"
}

variable DO_size {
  type = string
  default = "s-1vcpu-1gb"
}

variable DO_image {
  type = string
  default = "ubuntu-20-04-x64"
}

source digitalocean mysql {
  api_token = var.DO_TOKEN
  region = var.DO_region
  size = var.DO_size
  image = var.DO_image
  snapshot_name = "mysql8_droplet"
  ssh_username = "root"
}

build {
  sources = [ "source.digitalocean.mysql" ]
  provisioner ansible {
    playbook_file = "./playbook.yaml"
  }
}
