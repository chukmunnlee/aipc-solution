resource digitalocean_ssh_key default-key {
  name = "default-key"
  public_key = file("../keys/mykey.pub")
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
    private_key = file("../keys/mykey")
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

