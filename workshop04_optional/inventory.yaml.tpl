all:
   vars:
      ansible_user: ${user}
      ansible_connection: ssh
      ansible_private_key_file: ${private_key}
      ndb_tar_gz: https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-8.0.25-linux-glibc2.12-x86_64.tar.gz
      ndb_package: mysql-cluster-8.0.25-linux-glibc2.12-x86_64.tar.gz
      ndb_dir: mysql-cluster-8.0.25-linux-glibc2.12-x86_64
   hosts:
      %{~ for node_num, ip in nodes ~}
      node-${node_num}:
         ansible_host: ${ip}
      %{~ endfor ~}
   children:
      sql_node:
         hosts:
            node-0:
      data_nodes:
         %{~ for node_num in data_node_count ~}
         hosts:
            node-${node_num}:
         %{~ endfor ~}
