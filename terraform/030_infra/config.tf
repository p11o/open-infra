terraform {
  backend "kubernetes" {
    secret_suffix    = "state-030-infra"
    config_path      = "~/.kube/config"
  }
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
    }
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

provider "postgresql" {
  host            = "172.19.0.101"
  port            = 5432
  database        = "postgres"
  username        = "postgres"
  # TODO single source and hide password
  password        = "secretpassword"
  # TODO figure out how to configure ssl in postgres
  sslmode         = "disable"
  connect_timeout = 15
}