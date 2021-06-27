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

variable CS_password {
	type = string
	default = "changeit"
}

variable CS_version {
	type = string
	description = "Code Server version"
	default = "3.10.2"
}

source digitalocean code-server {
	api_token = var.DO_token
	region = var.DO_region
	image = var.DO_image
	size = var.DO_size
	snapshot_name = "code-server-${var.CS_version}"
	ssh_username = "root"
}

build {
	sources = [
		"source.digitalocean.code-server"
	]

	provisioner ansible {
		playbook_file = "./playbook.yaml"
		extra_arguments = [
			"-e", "code_server_version=${var.CS_version}",
			"-e", "install_dir=/opt/tmp"
		]
	}
}
