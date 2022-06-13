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
  version    = var.gitea_version

  values = [
    file("./helm/gitea/values.yaml")
  ]

  set {
    name = "gitea.oauth[0].name"
    value = "idp"
  }
  set {
    name = "gitea.oauth[0].provider"
    value = "openidConnect"
  }
  set {
    name = "gitea.oauth[0].key"
    value = "gitea"
  }
  set {
    name = "gitea.oauth[0].secret"
    value = keycloak_openid_client.gitea_client.client_secret
  }
  set {
    name = "gitea.oauth[0].autoDiscoverUrl"
    value = "http://idp.infra.local/auth/realms/infra/.well-known/openid-configuration"
  }
}

resource "keycloak_openid_client" "gitea_client" {
  realm_id            = keycloak_realm.infra.id
  client_id           = "gitea"

  name                = "gitea"
  enabled             = true
  standard_flow_enabled = true
  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = [
    "http://gitea.infra.local/user/oauth2/idp/callback"
  ]

  login_theme = "keycloak"

}

resource "kong_service" "gitea" {
    name        = "gitea"
    protocol    = "http"
    host        = "${helm_release.gitea.name}-http.${helm_release.gitea.namespace}.svc.cluster.local"
    port        = 3000
}

resource "kong_route" "gitea" {
    name            = "gitea"
    protocols       = [ "http", "https" ]
    hosts           = [ "gitea.infra.local" ]
    service_id       = kong_service.gitea.id
}
