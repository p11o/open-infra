provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

# tf state
terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/.kube/config"
  }
}