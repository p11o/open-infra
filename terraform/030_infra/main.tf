
######
# Kong

resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
  }
}

resource "helm_release" "kong" {
  name       = "kong"

  repository = "https://charts.konghq.com"
  chart      = "kong"
  namespace  = kubernetes_namespace.kong.id

  values = [
    file("helm/kong.yaml")
  ]
}


#########
# Concourse


# db
resource "postgresql_database" "concourse" {
  name              = "concourse"
  owner             = postgresql_role.concourse.name
  allow_connections = true
}

resource "postgresql_role" "concourse" {
  name     = "concourse"
  login    = true
  # TODO single source and hide password
  password = "secretconcoursepassword"
}

resource "kubernetes_namespace" "concourse" {
  metadata {
    name = "concourse"
  }
}

resource "helm_release" "concourse" {
  name       = "concourse"

  repository = "https://concourse-charts.storage.googleapis.com"
  chart      = "concourse"
  namespace  = kubernetes_namespace.concourse.id

  values = [
    file("helm/concourse.yaml")
  ]

  depends_on = [ postgresql_database.concourse ]
}