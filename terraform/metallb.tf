# metallb
# This should only be created for local dev to assign IPs to LoadBalancer types
resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

variable "metallb_ip_range" {
  type        = string
  description = "IP of the node"
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = kubernetes_namespace.metallb_system.metadata.0.name

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  values = [
    file("./helm/metallb/values.yaml")
  ]

  set {
    name  = "configInline.address-pools[0].addresses[0]"
    value = var.metallb_ip_range
  }
}
