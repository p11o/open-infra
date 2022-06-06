# tf state
terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config"
  }
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = ">= 3.0.0"
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

provider "keycloak" {
    client_id     = "admin-cli"
    username      = var.keycloak_admin_user
    password      = var.keycloak_admin_password
    url           = "http://idp.infra.local"
}
