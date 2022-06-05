locals {
  nginx_tcp_name = "nginx-tcp"
}

# tcp LB
resource "kubernetes_namespace" "nginx_tcp" {
  metadata {
    name = local.nginx_tcp_name
  }
}

resource "helm_release" "nginx_tcp" {
  depends_on = [helm_release.metallb]

  name      = local.nginx_tcp_name
  namespace = kubernetes_namespace.nginx_tcp.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version

  set { 
    name  = "controller.service.enableHttp"
    value = true
  }

  set {
    name = "tcp.22"
    value = "gitea/gitea-ssh:22"
  }

}
