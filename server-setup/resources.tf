// data
data digitalocean_ssh_key aipc {
  name = "aipc"
}

data cloudflare_zone dns-zone {
  name = var.CF_zone
}

// resources
resource digitalocean_droplet aipc-control {
  name = "aipc-control"
  image = var.DO_image
  size = var.DO_size
  region = var.DO_region

  ssh_keys = [ data.digitalocean_ssh_key.aipc.fingerprint ]
}

resource local_file root-at-ip {
  filename = "root@${digitalocean_droplet.aipc-control.ipv4_address}"
}

output aipc_control_ip {
  value = digitalocean_droplet.aipc-control.ipv4_address
}

// outputs
output aipc_key {
  value = data.digitalocean_ssh_key.aipc.fingerprint
}

output dns_zone {
  value = data.cloudflare_zone.dns-zone
}

