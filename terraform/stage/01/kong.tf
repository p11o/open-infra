# # kong
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
  version    = var.kong_version

  set {
    name = "proxy.type"
    value = "ClusterIP"
  }

  set {
    name = "ingressController.enabled"
    value = false
  }

  set {
    name = "dblessConfig.config"
    value = <<EOT
_format_version: "2.1"

services:
- name: concourse
  url: http://${helm_release.concourse.name}-web.${helm_release.concourse.namespace}.svc.cluster.local:8080
  routes:
  - name: concourse
    hosts:
    - concourse.infra.local
- name: gitea
  url: http://${helm_release.gitea.name}-http.${helm_release.gitea.namespace}.svc.cluster.local:3000
  routes:
  - name: gitea
    hosts:
    - gitea.infra.local
- name: keycloak
  url: http://${helm_release.keycloak.name}-keycloak.${helm_release.keycloak.namespace}.svc.cluster.local
  routes:
  - name: keycloak
    hosts:
    - idp.infra.local
EOT
  
  }
}

resource "kubernetes_ingress_v1" "ingress_infra" {
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
