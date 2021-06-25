locals {
  DO_image = "code-server-${var.CS_version}"
}

data digitalocean_image code-server {
  name = local.DO_image
}

resource digitalocean_ssh_key default-key {
  name = "default-key"
  public_key = file(var.key_public)
}

resource digitalocean_droplet code-server {
  name = "code-server"
  image = data.digitalocean_image.code-server.id
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [ digitalocean_ssh_key.default-key.fingerprint ]
}

resource local_file root_at_ip {
  filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
}

resource local_file inventory {
  filename = "inventory.yaml"
  content = templatefile("./inventory.yaml.tpl", {
    ip = digitalocean_droplet.code-server.ipv4_address,
    private_key = var.key_private,
    password = var.CS_password,
    user = "root"
  })
}

output code-server-domain {
  value = "code-${digitalocean_droplet.code-server.ipv4_address}.nip.io"
}
