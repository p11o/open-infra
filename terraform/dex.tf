# oidc
resource "kubernetes_namespace" "dex" {
  metadata {
    name = "dex"
  }
}

resource "helm_release" "dex" {
  name      = "dex"
  namespace = kubernetes_namespace.dex.metadata.0.name

  repository = "https://charts.dexidp.io"
  chart      = "dex"
  version    = var.dex_version

  values = [
    file("./helm/dex/values.yaml")
  ]
}
