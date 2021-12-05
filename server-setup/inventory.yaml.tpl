all:
   vars:
      ansible_user: root
      ansible_connection: ssh
      ansible_ssh_private_key_file: ${private_key}

      hashicorp_bins:
      - https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
      - https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip
      docker_machine_bin: https://gitlab-docker-machine-downloads.s3.amazonaws.com/main/docker-machine-Linux-aarch64
      fred_pub: https://drive.google.com/u/0/uc?id=17pBBYJhRkyrfVhLu44e23CA2PbeXPuMg&export=download
   
   hosts:
      ${hostname}:
         ansible_host: ${host_ip}
