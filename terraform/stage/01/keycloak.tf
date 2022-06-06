# oidc
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

variable "keycloak_admin_password" {
  default = "adminpassword"
}

variable "keycloak_admin_user" {
    default = "admin"
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
    value = var.keycloak_admin_user
  }
  set {
    name = "auth.adminPassword"
    value = var.keycloak_admin_password
  }

}


resource "keycloak_realm" "infra" {
  depends_on = [helm_release.keycloak]
  realm   = "infra"
  enabled = true
}


resource "keycloak_user" "user" {
  realm_id = keycloak_realm.infra.id
  username = "admin"
  enabled  = true

  email      = "admin@example.com"
  first_name = "Admin"
  last_name  = ""
  initial_password {
      value = "adminpassword"
  }
}
