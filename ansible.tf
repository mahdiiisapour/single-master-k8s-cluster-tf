resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
     ansible_group_master_servers = hcloud_server.kube-master.*.labels.ansible-group,
     hostname_master_servers = hcloud_server.kube-master.*.name,
     hostname_master_servers_ip = hcloud_server.kube-master.*.ipv4_address,
     ansible_group_worker_servers = hcloud_server.kube-worker.*.labels.ansible-group,
     hostname_worker_servers = hcloud_server.kube-worker.*.name,
     hostname_worker_servers_ip = hcloud_server.kube-worker.*.ipv4_address
    }
  )
  filename = "ansible/inventory.ini"
}


resource "local_file" "ansible_cfg" {
  content = <<-EOT
      [defaults]
      inventory=inventory.ini
      remote_user=${var.remote_usr}
      host_key_checking=False
      [privilege_escalation]
      become=False
      become_ask_pass=False
      become_method=sudo
      become_user=root
    EOT
  filename = "ansible/ansible.cfg"
}


resource local_file ansible_vars {
  content = <<-EOT
      VIP_MASTERS : ${var.lb_masters_private_ip}
      VIP_WORKERS : ${var.lb_workers_private_ip}
      APISERVER_SRC_PORT : ${var.services_masters_source_port}
      cp_endpoint : '${hcloud_load_balancer.masters_lb.ipv4}:${var.services_masters_source_port}'
      home_directory : ${var.home_dir}
      remote_username : ${var.remote_usr}
      cri_socket : ${var.cri_socket}
      pod_subnet : ${var.pod_subnet}
      cluster_name : ${var.cluster_name}
      kubernetes_version : ${var.kubernetes_version}
      kubernetes_package_version : ${var.kubernetes_package_version}
      k8s_repo_version: '${var.k8s_repo_version}'
      helm_version : ${var.helm_version}
      containerd_version : ${var.containerd_version}
      cilium_version : ${var.cilium_version}
      keepalived_version : ${var.keepalived_version}
      ingress_nginx_version: ${var.ingress_nginx_version}
      eth_name: ${var.eth_name}
    EOT
  filename = "ansible/k8s-ha-ansible/roles/k8s-ha-ansible/vars/main.yml"
}


resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "sleep 45; export ANSIBLE_CONFIG=ansible/ansible.cfg; ansible-playbook ansible/k8s-ha-ansible/k8s-ha-deployment.yaml"
  }
  depends_on = [ hcloud_server.kube-master, hcloud_server.kube-worker ]
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [
    null_resource.playbook,        # Explicitly depend on the playbook to run after it
  ]

  provisioner "remote-exec" {
    inline = [
      "cp /etc/kubernetes/admin.conf /tmp/kubeconfig"
    ]

    connection {
      type     = "ssh"
      host     = hcloud_server.kube-master[0].ipv4_address
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
    }
  }

  # Fetch kubeconfig to local path
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no root@${hcloud_server.kube-master[0].ipv4_address}:/tmp/kubeconfig ./kubeconfig"
  }
}
