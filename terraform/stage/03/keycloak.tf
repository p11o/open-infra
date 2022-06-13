resource "keycloak_realm" "infra" {
  realm   = "infra"
  enabled = true
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


resource "keycloak_user" "user" {
  realm_id = keycloak_realm.infra.id
  username = "admin"
  enabled  = true

  email      = "admin@example.com"
  first_name = "Admin"
  last_name  = ""
  initial_password {
      value = "adminpassword"
  }
}
