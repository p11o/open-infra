# # concourse
# resource "kubernetes_namespace" "concourse" {
#   metadata {
#     name = "concourse"
#   }
# }

# resource "helm_release" "concourse" {
#   name      = "concourse"
#   namespace = kubernetes_namespace.concourse.metadata.0.name

#   repository = "https://concourse-charts.storage.googleapis.com/"
#   chart      = "concourse"
#   version    = var.concourse_version

#   values = [
#     file("./helm/concourse/values.yaml")
#   ]
# }
