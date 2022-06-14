resource "keycloak_realm" "infra" {
  realm   = "infra"
  enabled = true
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
