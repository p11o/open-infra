# tf state
terraform {
  backend "kubernetes" {
    secret_suffix = "stage02-state"
    config_path   = "~/.kube/config"
  }
  required_providers {
    kong = {
      source = "noderadius/kong"
      version = ">= 6.7.0"
    }
  }
}

# providers
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind" 
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kong" {
    kong_admin_uri = "http://kong.infra.local"
}



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
  version    = "7.1.18"


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

  set {
    name = "infra.host"
    value = "idp.infra.local"
  }
}

output admin_user {
  value = var.keycloak_admin_user
}

output admin_password {
  value = var.keycloak_admin_password
}


resource "kong_service" "keycloak" {
    name        = "keycloak"
    protocol    = "http"
    host        = "${helm_release.keycloak.name}-keycloak.${helm_release.keycloak.namespace}.svc.cluster.local"
    port        = 80
}

resource "kong_route" "keycloak" {
    name            = "keycloak"
    protocols       = [ "http", "https" ]
    hosts           = [ "idp.infra.local" ]
    service_id       = kong_service.keycloak.id
}
