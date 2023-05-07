resource "hcloud_load_balancer" "workers_lb" {
  name               = "workers_lb"
  load_balancer_type = "lb11"
  location           = var.location
  labels = {
    type = "workers_lb"
  }

  dynamic "target" {
    for_each = hcloud_server.kube-worker
    content {
      type      = "server"
      server_id = target.value["id"]
    }
  }

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_service" "workers_service_1" {
  load_balancer_id = hcloud_load_balancer.workers_lb.id
  protocol         = var.services_protocol
  listen_port      = var.services_workers_port_1
  destination_port = var.services_workers_port_1

  health_check {
    protocol = var.services_protocol
    port     = var.services_workers_port_1
    interval = "10"
    timeout  = "10"
    http {
      path         = "/"
      status_codes = ["2??", "3??"]
    }
  }
}

resource "hcloud_load_balancer_service" "workers_service_2" {
  load_balancer_id = hcloud_load_balancer.workers_lb.id
  protocol         = var.services_protocol
  listen_port      = var.services_workers_port_2
  destination_port = var.services_workers_port_2

  health_check {
    protocol = var.services_protocol
    port     = var.services_workers_port_2
    interval = "10"
    timeout  = "10"
    http {
      path         = "/"
      status_codes = ["2??", "3??"]
    }
  }
}

resource "hcloud_load_balancer_network" "workers_network" {
  load_balancer_id        = hcloud_load_balancer.workers_lb.id
  subnet_id               = hcloud_network_subnet.hc_private_subnet.id
  enable_public_interface = "true"
  ip                      = var.lb_workers_private_ip
  depends_on = [
    hcloud_network_subnet.hc_private_subnet
  ]
}