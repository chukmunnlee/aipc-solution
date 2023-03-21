resource docker_volume mysql_vol {
  name = "mysql_vol"
}

resource docker_image "bgg_database" {
  name = "chukmunnlee/bgg-database:v3.1"
}

resource docker_image "bgg_backend" {
  name = "chukmunnlee/bgg-backend:v3"
}

resource docker_network "bgg_net" {
  name = "bgg-net"
}

resource docker_container bgg_database {
  name = "bgg-database"
  image = docker_image.bgg_database.image_id

  ports {
    internal = 3306
    external = 3306
  }

  volumes {
    volume_name = docker_volume.mysql_vol.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.bgg_net.id
  }
}

resource docker_container bgg_backend {
  count = 3
  name = "bgg-backend-${count.index}"
  image = docker_image.bgg_backend.image_id

  env = [
    "BGG_DB_USER=root",
    "BGG_DB_PASSWORD=changeit",
    "BGG_DB_HOST=${docker_container.bgg_database.name}",
  ]

  ports {
    internal = 3000
    external = 8080 + count.index
  }

  networks_advanced {
    name = docker_network.bgg_net.id
  }
}

resource local_file nginx_conf {
  content = templatefile("nginx.conf.tftpl", {
    docker_host = var.docker_host,
    ports = docker_container.bgg_backend[*].ports[0].external
  })
  filename = "nginx.conf"
  file_permission = "0644"
}

data digitalocean_ssh_key aipc {
  name = "aipc"
}

resource digitalocean_droplet nginx {
  name = "nginx"
  image = var.do_image
  region = var.do_region
  size = var.do_size
  ssh_keys = [ data.digitalocean_ssh_key.aipc.id ]
  tags = [ "nginx" ]

  connection {
    type = "ssh"
    user = "root"
    private_key = file("/home/cmlee/Insync/chukmunnlee@gmail.com/linux/cloud/stackup/aipc")
    host = self.ipv4_address
  }

  provisioner remote-exec {
    inline = [
      "/usr/bin/apt update -y",
      "/usr/bin/apt upgrade -y --force-yes",
      "/usr/bin/apt install nginx -y --force-yes",
      "/usr/bin/systemctl enable nginx",
      "/usr/bin/systemctl start nginx"
    ]
  }
  provisioner file {
    source = local_file.nginx_conf.filename
    destination = "/etc/nginx/nginx.conf"
  }
  provisioner remote-exec {
    inline = [
      "/usr/bin/systemctl restart nginx",
    ]
  }
}

resource local_file root_at_droplet {
  content = ""
  filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
  file_permission = "0444"
}

output ports {
  value = docker_container.bgg_backend[*].ports[0].external
}

output nginx_ipv4 {
  value = digitalocean_droplet.nginx.ipv4_address
}
