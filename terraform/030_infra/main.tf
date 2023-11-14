
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
# Airflow

# db
resource "postgresql_database" "airflow" {
  name              = "airflow"
  owner             = postgresql_role.airflow.name
  allow_connections = true
}

resource "postgresql_role" "airflow" {
  name     = "airflow"
  login    = true
  # TODO single source and hide password
  password = "secretairflowpassword"
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "helm_release" "airflow" {
  name       = "airflow"

  repository = "https://airflow.apache.org"
  chart      = "airflow"
  namespace  = kubernetes_namespace.airflow.id

  values = [
    file("helm/airflow.yaml")
  ]

  depends_on = [ postgresql_database.airflow ]
}