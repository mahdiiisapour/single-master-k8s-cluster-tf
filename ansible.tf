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
      MASTER01_HOST : ${hcloud_server.kube-master[0].name}
      MASTER01_IP : ${hcloud_server.kube-master[0].ipv4_address}
      MASTER02_HOST : ${hcloud_server.kube-master[1].name}
      MASTER02_IP : ${hcloud_server.kube-master[1].ipv4_address}
      MASTER03_HOST : ${hcloud_server.kube-master[2].name}
      MASTER03_IP : ${hcloud_server.kube-master[2].ipv4_address}
      WORKER01_HOST : ${hcloud_server.kube-worker[0].name}
      WORKER01_IP : ${hcloud_server.kube-worker[0].ipv4_address}
      WORKER02_HOST : ${hcloud_server.kube-worker[1].name}
      WORKER02_IP : ${hcloud_server.kube-worker[1].ipv4_address}
      WORKER03_HOST : ${hcloud_server.kube-worker[2].name}
      WORKER03_IP : ${hcloud_server.kube-worker[2].ipv4_address}
      VIP_MASTERS : ${var.lb_masters_private_ip}
      VIP_WORKERS : ${var.lb_workers_private_ip}
      APISERVER_DEST_PORT : ${var.services_masters_port}
      APISERVER_SRC_PORT : ${var.services_masters_source_port}
      cp_endpoint : '${hcloud_load_balancer.masters_lb.ipv4}:${var.services_masters_port}'
      home_directory : ${var.home_dir}
      remote_username : ${var.remote_usr}
      kubernetes_version : ${var.kubernetes_version}
      helm_version : ${var.helm_version}
      containerd_version : ${var.containerd_version}
      cilium_version : ${var.cilium_version}
      cri_socket : ${var.cri_socket}
      pod_subnet : ${var.pod_subnet}
      cluster_name : ${var.cluster_name}
      haproxy_version : ${var.haproxy_version}
      keepalived_version : ${var.keepalived_version}
      ingress_nginx_version: ${var.ingress_nginx_version}
      eth_master01 : ${var.eth_master01}
      eth_master02 : ${var.eth_master02}
      eth_master03 : ${var.eth_master03}
      eth_worker01 : ${var.eth_worker01}
      eth_worker02 : ${var.eth_worker02}
      eth_worker03 : ${var.eth_worker03}
    EOT
  filename = "ansible/k8s-ha-ansible/roles/k8s-ha-ansible/vars/main.yml"
}


resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "sleep 45; export ANSIBLE_CONFIG=ansible/ansible.cfg; ansible-playbook ansible/k8s-ha-ansible/k8s-ha-deployment.yaml"
  }
  depends_on = [ hcloud_server.kube-master, hcloud_server.kube-worker ]
}