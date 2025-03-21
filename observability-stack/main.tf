provider "helm" {
  kubernetes {
    config_path = "/root/code/single-master-k8s-cluster-tf/kubeconfig"
  }
}
provider "kubernetes" {
  config_path = "/root/code/single-master-k8s-cluster-tf/kubeconfig" 
}

# Create namespaces
resource "kubernetes_namespace" "alloy" {
  metadata {
    name = "alloy"
  }
}

resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "kubernetes_namespace" "tempo" {
  metadata {
    name = "tempo"
  }
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

# Deploy Alloy with custom configurations for logs, metrics, and traces
resource "helm_release" "alloy" {
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  namespace  = kubernetes_namespace.alloy.metadata[0].name

  values = [
    <<EOF
logs:
  enabled: true
  loki:
    endpoint: "http://loki.loki.svc.cluster.local:3100"
    labels:
      job: alloy
    tenantID: ""
    batchWait: 1s
    batchSize: 1048576

metrics:
  enabled: true
  prometheus:
    endpoint: "http://prometheus-server.prometheus.svc.cluster.local:9090"

traces:
  enabled: true
  tempo:
    endpoint: "http://tempo.tempo.svc.cluster.local:3100"
EOF
  ]
}

# Deploy Loki
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = kubernetes_namespace.loki.metadata[0].name
}

# Deploy Tempo
resource "helm_release" "tempo" {
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  namespace  = kubernetes_namespace.tempo.metadata[0].name
}

# Deploy Grafana with NodePort service type
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.grafana.metadata[0].name

  values = [
    <<EOF
adminUser: admin
adminPassword: admin    
service:
  type: NodePort
  nodePort: 32081  # Optional: specify a specific NodePort or let Kubernetes assign one
EOF
  ]
}


