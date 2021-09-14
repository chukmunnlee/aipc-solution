# Docker
resource docker_image img-dov-bear {
  name = "chukmunnlee/dov-bear:v4"
}

resource docker_container cont-dov-bear {
  count = var.mysql_cluster_nodes
  name = "dov-bear-${count.index}"
  image = docker_image.img-dov-bear.latest
  env = [
    "INSTANCE_NAME=\"dov-bear-${count.index}\""
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

resource local_file inventory {
  content = templatefile("./inventory.yaml.tpl", {
    user = "root",
    private_key = var.key_private,
    nodes = zipmap(
      range(var.mysql_cluster_nodes),
      # droplet private IPV4 address
      local.container_ip_ports 
    ),
    data_node_count = range(1, var.mysql_cluster_nodes)
  })
  filename = "inventory.yaml"
}

output external_ports {
  description = "Container external ports"
  value = local.container_ip_ports
}
