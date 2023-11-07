#########
# Metallb

resource "helm_release" "metallb" {
  name       = "metallb"

  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "metallb"
}

# Instead of using the stock kubernetes_manifest resource
# we are using null_resource because kubernetes_manifest
# will check to see if the crd is there.  If it is not, it fails.
locals {
  metallb_files = fileset("${path.module}/k8s/metallb", "*")
  metallb_hash = md5(join("", [for f in local.metallb_files : filemd5("${path.module}/k8s/metallb/${f}")]))
}

resource "null_resource" "metallb_config" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/metallb"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete  IPAddressPool,L2Advertisement -l component=metallb-config"
  }

  triggers = {
    version = local.metallb_hash
  }

  depends_on = [ helm_release.metallb ]
}

#####
# DNS
resource "kubernetes_namespace" "dns" {
  metadata {
    name = "dns"
  }
}

resource "helm_release" "dns" {
  name       = "coredns"

  repository = "https://coredns.github.io/helm"
  chart      = "coredns"
  namespace  = kubernetes_namespace.dns.id

  values = [
    file("helm/coredns.yaml")
  ]
}

##########
# Postgres

resource "kubernetes_namespace" "db" {
  metadata {
    name = "db"
  }
}

resource "helm_release" "db" {
  name       = "postgres"

  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  namespace  = kubernetes_namespace.db.id

  values = [
    file("helm/postgres.yaml")
  ]
}