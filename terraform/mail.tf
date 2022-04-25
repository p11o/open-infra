resource "kubernetes_namespace" "mail" {
  metadata {
    name = "mail"
  }
}

resource "kubernetes_deployment_v1" "mail" {
  metadata {
    name      = "mail"
    namespace = kubernetes_namespace.mail.metadata.0.name
    labels = {
      name = "mail"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "mail"
      }
    }

    template {
      metadata {
        labels = {
          name = "mail"
        }
      }

      spec {
        container {
          image = "bytemark/smtp"
          name  = "mail"
          port {
            container_port = 25
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mail" {
  metadata {
    name      = "mail"
    namespace = kubernetes_namespace.mail.metadata[0].name
  }


  spec {
    selector = {
      name = kubernetes_deployment_v1.mail.metadata[0].labels.name
    }
    port {
      port = 25
    }
  }
}
