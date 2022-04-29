# oidc
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

resource "helm_release" "keycloak" {
  name      = "bitnami"
  namespace = kubernetes_namespace.keycloak.metadata.0.name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = var.keycloak_version

  values = [
    file("./helm/keycloak/values.yaml")
  ]
}
