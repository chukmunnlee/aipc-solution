all:
   vars:
      ansible_user: ${user}
      ansible_connection: ssh
      ansible_private_key_file: ${private_key}
      password: ${password}
   hosts:
      code-server:
         ansible_host: ${ip}
