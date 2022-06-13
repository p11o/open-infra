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
  version    = var.kong_version

  set {
    name = "proxy.type"
    value = "ClusterIP"
  }

  set {
    name = "admin.enabled"
    value = true
  }
  set {
    name = "admin.http.enabled"
    value = true
  }
  set {
    name = "admin.tls.enabled"
    value = false
  }
  set {
    name = "postgresql.enabled"
    value = true
  }
  set {
    name = "postgresql.auth.database"
    value = "kong"
  }
  set {
    name = "postgresql.auth.username"
    value = "kong"
  }
  set {
    name = "postgresql.auth.password"
    value = "kongpassword123"
  }
  set {
    name = "env.database"
    value = "postgres"
  }
  set {
    name = "env.pg_password"
    value = "kongpassword123"
  }
  set {
    name = "env.pg_database"
    value = "kong"
  }
}

resource "kubernetes_ingress_v1" "ingress_infra" {

  depends_on = [helm_release.nginx_tcp]

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

    rule {
      host = "kong.infra.local"
      http {
        path {
          backend {
            service {
              name = "kong-kong-admin"
              port {
                number = 8001
              }
            }
          }
        }
      }
    }
  }
}
