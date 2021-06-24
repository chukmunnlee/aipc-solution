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
  default = "s-1vcpu-2gb"
}
