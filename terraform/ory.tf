# ory
resource "kubernetes_namespace" "ory" {
  metadata {
    name = "ory"
  }
}

resource "helm_release" "ory" {
  name      = "ory"
  namespace = kubernetes_namespace.ory.metadata.0.name

  repository = "https://k8s.ory.sh/helm/charts"
  chart      = "kratos"
  version    = var.kratos_version

  values = [
    file("./helm/kratos/values.yaml")
  ]
}

resource "helm_release" "oauth2_proxy" {
  name      = "bitnami"
  namespace = kubernetes_namespace.ory.metadata.0.name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "oauth2-proxy"
  version    = var.oauth2_proxy_version

  values = [
    file("./helm/oauth2-proxy/values.yaml")
  ]
}
