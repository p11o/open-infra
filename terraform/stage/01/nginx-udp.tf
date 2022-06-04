locals {
  nginx_udp_name = "nginx-udp"
}

# udp LB
resource "kubernetes_namespace" "nginx_udp" {
  metadata {
    name = local.nginx_udp_name
  }
}

resource "helm_release" "nginx_udp" {
  depends_on = [helm_release.metallb]

  name      = local.nginx_udp_name
  namespace = kubernetes_namespace.nginx_udp.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  # version    = var.ingress_nginx_version

  set {
    name = "controller.service.enableHttp"
    value = false
  }

  set {
    name = "controller.service.enableHttps"
    value = false
  }

  set {
    name = "ingressClassResource.name"
    value = local.nginx_udp_name
  }

  set {
    name = "ingressClass"
    value = local.nginx_udp_name
  }

  set {
    name = "udp.53"
    value = "${kubernetes_namespace.coredns.metadata.0.name}/coredns-coredns:53"
}
