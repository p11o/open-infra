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
