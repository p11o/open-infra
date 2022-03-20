# nginx
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = kubernetes_namespace.nginx.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    file("./helm/nginx/values.yaml")
  ]
}