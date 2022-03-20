# gitea
resource "kubernetes_namespace" "gitea" {
  metadata {
    name = "gitea"
  }
}

resource "helm_release" "gitea" {
  name      = "gitea"
  namespace = kubernetes_namespace.gitea.metadata.0.name

  repository = "https://dl.gitea.io/charts/"
  chart      = "gitea"

  values = [
    file("./helm/gitea/values.yaml")
  ]
}
