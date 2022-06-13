# tf state
terraform {
  backend "kubernetes" {
    secret_suffix = "stage01-state"
    config_path   = "~/.kube/config"
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
