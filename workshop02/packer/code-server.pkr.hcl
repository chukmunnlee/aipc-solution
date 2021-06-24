variable DO_token {
	type = string
	sensitive = true
	default = env("TF_VAR_DO_token")
}
variable DO_region {
	type = string
	default = "sgp1"
}
variable DO_size {
	type = string
	default = "s-1vcpu-1gb"
}
variable DO_image {
	type = string
	default = "ubuntu-20-04-x64"
}

variable VERSION {
	type = string
	description = "Code Server version"
	default = "123"
}

source digitalocean code-server {
	api_token = var.DO_token
	region = var.DO_region
	image = var.DO_image
	size = var.DO_size
	snapshot_name = "code-server-${var.VERSION}"
	ssh_username = "root"
}

build {
	sources = [
		"source.digitalocean.code-server"
	]
}
