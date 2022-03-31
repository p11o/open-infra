# coredns
resource "kubernetes_namespace" "coredns" {
  metadata {
    name = "coredns"
  }
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
}