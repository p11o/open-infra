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

resource "kubernetes_role_v1" "argo_gitea" {
  metadata {
    name      = "gitea"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }

  rule {
    api_groups = [""]
    resources  = ["workflows.argoproj.io"]
    verbs      = ["update", "list"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["watch", "get"]
  }
}

resource "kubernetes_role_binding_v1" "argo_gitea" {
  metadata {
    name      = "gitea"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitea"
    api_group = ""
    namespace = "argo"
  }
  role_ref {
    kind      = "Role"
    name      = "gitea"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_service_account_v1" "gitea" {
  metadata {
    name      = "gitea"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }
  # exports default_secret_name
}

resource "kubernetes_config_map_v1" "gitea_to_argo_config" {
  metadata {
    name      = "gitea-to-argo"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }

  data = {
    "default.conf.template" = "${file("./kubernetes/argo/configmap/nginx/default.conf.template")}"
  }
}

resource "kubernetes_deployment_v1" "gitea_to_argo" {
  metadata {
    name      = "gitea-to-argo"
    namespace = kubernetes_namespace.argo.metadata.0.name
    labels = {
      name = "gitea-to-argo"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        name = "gitea-to-argo"
      }
    }

    template {
      metadata {
        labels = {
          name = "gitea-to-argo"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx"
          port {
            container_port = 80
          }
          env {
            name = "GITEA_ARGO_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_service_account_v1.gitea.default_secret_name
                key  = "token"
              }
            }
          }

          volume_mount {
            mount_path = "/etc/nginx/templates"
            name       = "config"
            read_only  = true
          }
        }
        volume {
          name = "config"
          config_map {
            name = "gitea-to-argo"
            items {
              key  = "nginx.conf.template"
              path = "default.conf.template"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "gitea_to_argo" {
  metadata {
    name      = "gitea-to-argo"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }


  spec {
    selector = {
      name = "gitea-to-argo"
    }
    port {
      port = 80
    }
  }
}

# Use kubectl_manifest since there is no tf provider for argo crd's
resource "kubectl_manifest" "sample_workflow_template" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./kubernetes/argo/workflow-template/sample.yaml")
}

resource "kubectl_manifest" "sample_workflow_event_binding" {
  depends_on = [kubectl_manifest.sample_workflow_template]
  yaml_body  = file("./kubernetes/argo/workflow-event-binding/sample.yaml")
}

resource "kubectl_manifest" "docker_workflow_template" {
  depends_on = [helm_release.argo_workflows]
  yaml_body  = file("./kubernetes/argo/workflow-template/docker.yaml")
}

resource "kubectl_manifest" "docker_workflow_event_binding" {
  depends_on = [kubectl_manifest.docker_workflow_template]
  yaml_body  = file("./kubernetes/argo/workflow-event-binding/docker.yaml")
}