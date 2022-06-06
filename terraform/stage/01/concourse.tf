# concourse
resource "kubernetes_namespace" "concourse" {
  metadata {
    name = "concourse"
  }
}

resource "helm_release" "concourse" {
  name      = "concourse"
  namespace = kubernetes_namespace.concourse.metadata.0.name

  repository = "https://concourse-charts.storage.googleapis.com/"
  chart      = "concourse"
  version    = var.concourse_version

  values = [
    file("./helm/concourse/values.yaml")
  ]
  
    set {
        name = "web.env[3].name"
        value = "CONCOURSE_OIDC_CLIENT_ID"
    }
    set {
        name = "web.env[3].value"
        value = "concourse"
    }
    set {
        name = "web.env[4].name"
        value = "CONCOURSE_OIDC_CLIENT_SECRET"
    }
    set {
        name = "web.env[4].value"
        value = keycloak_openid_client.concourse_client.client_secret
    }
    set {
        name = "web.env[5].name"
        value = "CONCOURSE_OIDC_ISSUER"
    }
    set {
        name = "web.env[5].value"
        value = "http://idp.infra.local/auth/realms/infra"
    }

}

resource "keycloak_openid_client" "concourse_client" {
  realm_id            = keycloak_realm.infra.id
  client_id           = "concourse"

  name                = "concourse"
  enabled             = true

  standard_flow_enabled = true
  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = [
    "http://concourse.infra.local/sky/issuer/callback"
  ]

  login_theme = "keycloak"

}
