all:
  vars:
    ansible_connection: ssh
    ansible_user: root
    ansible_ssh_private_key_file: ${ssh_private_key}
  hosts:
    ${codeserver}:
      ansible_host: ${droplet_ip}
      codeserver_domain: ${codeserver_domain}
      codeserver_password: ${codeserver_password}
