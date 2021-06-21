# Docker
resource docker_image img-dov-bear {
  name = "chukmunnlee/dov-bear:v4"
}

resource docker_container cont-dov-bear {
  for_each = var.dov_instances
  name = each.value
  image = docker_image.img-dov-bear.latest
  env = [
    "INSTANCE_NAME=\"${each.value}\""
  ]
  ports {
    internal = 3000
  }
}

# Nginx
resource digitalocean_ssh_key default-key {
  name = "default-key"
  public_key = file("./keys/mykey.pub")
}

resource digitalocean_droplet nginx {
  name = "nginx"
  image = var.DO_image
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [ digitalocean_ssh_key.default-key.fingerprint ]
  user_data = file("./nginx-config.yaml")
}

resource local_file root_at_ip {
  filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}

output external_ports {
  description = "Container external ports"
  value = flatten(
    [ for c in docker_container.cont-dov-bear: 
      [ for p in c.ports: "${var.docker_host}:${p.external}" ]
    ]
  )
}

output nginx_ipv4_address {
  description = "Nginx IP address"
  value = digitalocean_droplet.nginx.ipv4_address
}
