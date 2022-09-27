# providers
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.9.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider digitalocean {
  token = var.DO_token
}

provider local { }

# variables
variable DO_token {
  type = string
  sensitive = true
}

# resources
resource digitalocean_ssh_key mykey {
  name = "default"
  public_key = file("../../keys/mykey.pub")
}

resource digitalocean_droplet code-server {
  name = "code-server"
  image = "ubuntu-20-04-x64"
  region = "sgp1"
  size = "s-1vcpu-1gb"
  ssh_keys = [ digitalocean_ssh_key.mykey.fingerprint ]
}

resource local_file root_at_ip {
  filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
}

resource local_file inventory {
  filename = "inventory.txt"
  content = "${digitalocean_droplet.code-server.ipv4_address} ansible_connection=ssh ansible_user=root ansible_private_key_file=../../keys/mykey"
}
