## Provider configurations 
variable DO_token {
  type = string
  description = "DigitalOcean API token"
  sensitive = true
}

variable DO_region {
  type = string
  default = "sgp1"
}

variable DO_size {
  type = string
  default = "s-1vcpu-2gb"
}

variable key_public {
  type = string
  default = "../../keys/mykey.pub"
}

variable key_private {
  type = string
  default = "../../keys/mykey"
}

variable CS_version {
  type = string
  description = "Code Server version"
  default = "3.10.2"
}

variable CS_password {
  type = string
  description = "Code Server password"
  sensitive = true
  default = "changeit"
}

