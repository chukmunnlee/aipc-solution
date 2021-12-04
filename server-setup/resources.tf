data digitalocean_ssh_key aipc {
  name = "aipc"
}

data cloudflare_zone hello-chuklee {
  name = var.CF_zone
}

/*
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
*/


output aipc_key {
  value = data.digitalocean_ssh_key.aipc.fingerprint
}

output hello_chuklee {
  value = data.cloudflare_zone.hello-chuklee
}

