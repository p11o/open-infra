############
# Kubernetes

data "external" "check_kind_cluster" {
  program = ["bash", "${path.module}/scripts/check_cluster.sh"]
}

resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = data.external.check_kind_cluster.result.exists == "false" ? "kind create cluster --config ${path.module}/kind/cluster.yaml" : "echo 'Cluster already exists'"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster"
  }
}
