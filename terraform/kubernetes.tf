resource "kubernetes_config_map_v1" "coredns" {
  metadata {
    name = "coredns"
    namespace = "kube-system"
  }

  data = {
    "Corefile" = "${file("./kubernetes/kube-system/configmap/coredns/Corefile")}"
  }
}