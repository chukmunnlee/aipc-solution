data digitalocean_ssh_key aipc {
  name = "aipc"
}

output aipc_key {
  value = data.digitalocean_ssh_key.aipc.fingerprint
}
