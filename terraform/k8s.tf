provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "mnt" {
  metadata {
    name = "mnt"
  }
}