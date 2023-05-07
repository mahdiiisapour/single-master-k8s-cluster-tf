output "kube_masters_status" {
  value = {
    for server in hcloud_server.kube-master :
    server.name => server.status
  }
}

output "kube_masters_ips" {
  value = {
    for server in hcloud_server.kube-master :
    server.name => server.ipv4_address
  }
}

output "kube_workers_status" {
  value = {
    for server in hcloud_server.kube-worker :
    server.name => server.status
  }
}

output "kube_workers_ips" {
  value = {
    for server in hcloud_server.kube-worker :
    server.name => server.ipv4_address
  }
}

output "lb_masters_ip" {
  description = "Load balancer Masters IP address"
  value       = hcloud_load_balancer.masters_lb.ipv4
}

output "lb_workers_ip" {
  description = "Load balancer Workers IP address"
  value       = hcloud_load_balancer.workers_lb.ipv4
}