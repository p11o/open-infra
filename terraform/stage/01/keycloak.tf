# oidc
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

variable "keycloak_admin_password" {
  default = "adminpassword"
}

resource "helm_release" "keycloak" {
  name      = "bitnami"
  namespace = kubernetes_namespace.keycloak.metadata.0.name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = var.keycloak_version


  set {
    name = "service.type"
    value = "ClusterIP"
  }

  set {
    name = "proxyAddressForwarding"
    value = true
  }

  set {
    name = "auth.adminUser"
    value = "admin"
  }
  set {
    name = "auth.adminPassword"
    value = var.keycloak_admin_password
  }

}
