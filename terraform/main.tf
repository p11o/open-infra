# tf state
terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config"
  }

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
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

provider "kubectl" {
  load_config_file = true
}

# metallb
# This should only be created for local dev to assign IPs to LoadBalancer types
resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = kubernetes_namespace.metallb_system.metadata.0.name

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  values = [
    file("./helm/metallb/values.yaml")
  ]
}

# nginx
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = kubernetes_namespace.nginx.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    file("./helm/nginx/values.yaml")
  ]
}

resource "kubernetes_ingress_v1" "ingress-nginx" {
  metadata {
    name      = "ingress-infra"
    namespace = kubernetes_namespace.kong.metadata.0.name
  }


  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = "kong-kong-proxy"
        port {
          number = 80
        }
      }
    }
  }
}


# kong
resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
  }
}

resource "helm_release" "kong" {
  name      = "kong"
  namespace = kubernetes_namespace.kong.metadata.0.name

  repository = "https://charts.konghq.com"
  chart      = "kong"

  values = [
    file("./helm/kong/values.yaml")
  ]
}

# gitea
resource "kubernetes_namespace" "gitea" {
  metadata {
    name = "gitea"
  }
}

resource "helm_release" "gitea" {
  name      = "gitea"
  namespace = kubernetes_namespace.gitea.metadata.0.name

  repository = "https://dl.gitea.io/charts/"
  chart      = "gitea"

  values = [
    file("./helm/gitea/values.yaml")
  ]
}

# argo
resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

resource "helm_release" "argo_workflows" {
  name      = "argo-workflows"
  namespace = kubernetes_namespace.argo.metadata.0.name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"

  values = [
    file("./helm/argo-workflows/values.yaml")
  ]
}

resource "kubectl_manifest" "gitea_argo_gitea_role" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./helm/argo-workflows/gitea/role.yaml")
}

resource "kubectl_manifest" "gitea_argo_gitea_service_account" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./helm/argo-workflows/gitea/service-account.yaml")
}

resource "kubectl_manifest" "gitea_argo_gitea_role_binding" {
  depends_on = [
    kubectl_manifest.gitea_argo_gitea_role,
    kubectl_manifest.gitea_argo_gitea_service_account,
  ]
  yaml_body = file("./helm/argo-workflows/gitea/role-binding.yaml")
}

resource "kubectl_manifest" "gitea_argo_proxy" {
  depends_on = [kubectl_manifest.gitea_argo_gitea_service_account]
  yaml_body  = file("./helm/argo-workflows/gitea/gitea-to-argo.yaml")
}

resource "kubectl_manifest" "sample_workflow_template" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./helm/argo-workflows/workflow/workflow-template/sample.yaml")
}

resource "kubectl_manifest" "sample_workflow_event_binding" {
  depends_on = [kubectl_manifest.sample_workflow_template]
  yaml_body  = file("./helm/argo-workflows/workflow/event-binding/sample.yaml")
}

resource "kubectl_manifest" "docker_workflow_template" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./helm/argo-workflows/workflow/workflow-template/docker.yaml")
}

resource "kubectl_manifest" "docker_workflow_event_binding" {
  depends_on = [kubectl_manifest.docker_workflow_template]
  yaml_body  = file("./helm/argo-workflows/workflow/event-binding/docker.yaml")
}