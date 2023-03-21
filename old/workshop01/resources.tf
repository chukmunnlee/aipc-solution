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

locals {
  container_ip_ports = flatten(
    [ for c in docker_container.cont-dov-bear: 
      [ for p in c.ports: "${var.docker_host}:${p.external}" ]
    ]
  )
}

# Nginx
resource digitalocean_ssh_key default-key {
  name = "default-key"
  public_key = file(var.key_public)
}

resource digitalocean_droplet nginx {
  name = "nginx"
  image = var.DO_image
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [ digitalocean_ssh_key.default-key.fingerprint ]

  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.key_private)
    host = self.ipv4_address
  }

  provisioner remote-exec {
    inline = [
      "/usr/bin/apt update -y",
      "/usr/bin/apt upgrade -y",
      "/usr/bin/apt install nginx -y",
    ]
  }
  provisioner file {
    source = "./${local_file.nginx_conf.filename}"
    destination = "/etc/nginx/nginx.conf"
  }
  provisioner remote-exec {
    inline = [
      "/usr/sbin/nginx -s reload"
    ]
  }
}

resource local_file root_at_ip {
  filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}

resource local_file nginx_conf {
  content = templatefile("./nginx.conf.tpl", {
    containers = local.container_ip_ports
  })
  filename = "nginx.conf"
}

output external_ports {
  description = "Container external ports"
  value = local.container_ip_ports
}

output nginx_ipv4_address {
  description = "Nginx IP address"
  value = digitalocean_droplet.nginx.ipv4_address
}
