## Provider configurations 
variable DO_token {
  type = string
  description = "DigitalOcean API token"
  sensitive = true
}

variable DO_image {
  type = string
  default = "ubuntu-20-04-x64"
}

variable DO_region {
  type = string
  default = "sgp1"
}

variable DO_size {
  type = string
  default = "s-1vcpu-1gb"
}

variable docker_host {
  type = string
  description = "Docker host. Get from DOCKER_HOST"
}

variable docker_port {
  type = number
  description = "Docker port. Get from DOCKER_HOST"
}

variable docker_cert_path {
  type = string
  description = "Docker host. Get from DOCKER_CERT_PATH"
}

variable dov_instances {
  type = set(string)
  default = [ "dov-1", "dov-2", "dov-3" ]
}

