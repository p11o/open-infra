# nginx
resource "kubernetes_namespace" "nginx_tcp" {
  metadata {
    name = "nginx-tcp"
  }
}

resource "helm_release" "nginx_tcp" {
  name      = "nginx-tcp"
  namespace = kubernetes_namespace.nginx_tcp.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version

  values = [
    file("./helm/nginx-tcp/values.yaml")
  ]
}

resource "kubernetes_namespace" "nginx_udp" {
  metadata {
    name = "nginx-udp"
  }
}

resource "helm_release" "nginx_udp" {
  name      = "nginx-udp"
  namespace = kubernetes_namespace.nginx_udp.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    file("./helm/nginx-udp/values.yaml")
  ]
}
