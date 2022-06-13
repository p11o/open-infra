# tf state
terraform {
  backend "kubernetes" {
    secret_suffix = "stage03-state"
    config_path   = "~/.kube/config"
  }
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = ">= 3.0.0"
    }
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


provider "keycloak" {
  client_id     = "admin-cli"
  username      = "admin"
  password      = "adminpassword"
  url           = "http://idp.infra.local"
}

provider "kong" {
    kong_admin_uri = "http://kong.infra.local"
}
