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

resource cloudflare_record a-lumya {
  zone_id = data.cloudflare_zone.dns-zone.zone_id
  name = "lumya"
  type = "A"
  proxied = true
  value = digitalocean_droplet.aipc-control.ipv4_address
}

resource local_file root-at-ip {
  filename = "root@${digitalocean_droplet.aipc-control.ipv4_address}"
  file_permission = "0664"
}

resource local_file ansible-inventory {
  filename = "setup/inventory.yaml"
  content = templatefile("inventory.yaml.tpl", 
    {
      hostname = digitalocean_droplet.aipc-control.name
      host_ip = digitalocean_droplet.aipc-control.ipv4_address
      private_key = var.private_key
    }
  )
  file_permission = "0664"
}

resource local_file add-host {
  filename = "setup/add-host.sh"
  content = templatefile("add-host.sh.tpl",
    {
      host_ip = digitalocean_droplet.aipc-control.ipv4_address
    }
  )
  file_permission = "0755"
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

