# coredns
resource "kubernetes_namespace" "coredns" {
  metadata {
    name = "coredns"
  }
}


data "external" "tcp_lb_addr" {
  depends_on = [helm_release.nginx_tcp]
  program = [
    "${path.module}/scripts/lb-ip.sh", helm_release.nginx_tcp.namespace
  ]
}

resource "helm_release" "coredns" {
  depends_on = [data.external.tcp_lb_addr]


  name      = "coredns"
  namespace = kubernetes_namespace.coredns.metadata.0.name

  repository = "https://coredns.github.io/helm"
  chart      = "coredns"
  #   version    = var.coredns_version

  set {
    name = "replicaCount"
    value = "1"
  }

  set {
    name = "isClusterService"
    value = "false"
  }

  set {
    name = "servers[0].port"
    value = "53"
  }


  set {
    name = "servers[0].zones[0].zone"
    value = "local"
  }

  set {
    name = "servers[0].plugins[0].name"
    value = "template"
  }

  set {
    name = "servers[0].plugins[0].parameters"
    value = "ANY ANY local"
  }

  set {
    name  = "servers[0].plugins[0].configBlock"
    value = "answer \"{{ .Name }} 60 IN A ${data.external.tcp_lb_addr.result.ip}\""
  }


  set {
    name = "servers[0].plugins[1].name"
    value = "ready"
  }


  set {
    name = "servers[0].plugins[2].name"
    value = "health"
  }

  set {
    name = "servers[0].plugins[2].configBlock"
    value = "lameduck 5s"
  }

}
