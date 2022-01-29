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

# tf state
terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/.kube/config"
  }
}

# metallb
resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  namespace  = kubernetes_namespace.metallb_system.metadata.0.name
  
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  values = [
    file("./helm/metallb/values.yaml")
  ]
}

# kong
resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
  }
}

resource "helm_release" "kong" {
  name       = "kong"
  namespace  = kubernetes_namespace.kong.metadata.0.name

  repository = "https://charts.konghq.com"
  chart      = "kong"
}