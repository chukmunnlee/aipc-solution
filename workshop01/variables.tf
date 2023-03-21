variable do_token {
  type = string
  sensitive = true
}

variable do_region {
  type = string
  default = "sgp1"
}

variable do_size {
  type = string
  default = "s-1vcpu-512mb-10gb"
}

variable do_image {
  type = string
  default = "ubuntu-20-04-x64"
}

variable docker_host {
  type = string
  default = "159.223.58.69"
}

variable docker_cert_path {
  type = string
  sensitive = true
}
