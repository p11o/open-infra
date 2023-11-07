terraform {
  backend "kubernetes" {
    secret_suffix    = "state-020-base"
    config_path      = "~/.kube/config"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind" 
}
