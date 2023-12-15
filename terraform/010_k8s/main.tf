############
# Kubernetes

variable "host_s3_path" {
  default = "/tmp/s3"
  type    = string
}

locals {
  cluster_config = templatefile("${path.module}/kind/cluster.yaml.tpl", { host_s3_path = var.host_s3_path })
}

data "external" "check_kind_cluster" {
  program = ["bash", "${path.module}/scripts/check_cluster.sh"]
}

resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = data.external.check_kind_cluster.result.exists == "false" ? "kind create cluster --config - <<EOF\n${local.cluster_config}\nEOF" : "echo 'Cluster already exists'"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster"
  }
}
