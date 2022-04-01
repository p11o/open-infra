# coredns
resource "kubernetes_namespace" "coredns" {
  metadata {
    name = "coredns"
  }
}

variable "nginx_tcp_ip_address" {
  type        = string
  description = "IP the tcp load balancer"
}

resource "helm_release" "coredns" {
  name      = "coredns"
  namespace = kubernetes_namespace.coredns.metadata.0.name

  repository = "https://coredns.github.io/helm"
  chart      = "coredns"
  version    = var.coredns_version

  values = [
    file("./helm/coredns/values.yaml")
  ]

  set {
    name  = "servers[0].plugins[0].configBlock"
    value = " answer \"{{ .Name }} 60 IN A ${var.nginx_tcp_ip_address}\" "
  }
}