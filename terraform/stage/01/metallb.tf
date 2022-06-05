# metallb
# This should only be created for local dev to assign IPs to LoadBalancer types
resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

data "external" "docker_ip_prefix" {
  program = [
    "scripts/host-ip-prefix.sh"
  ]
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = kubernetes_namespace.metallb_system.metadata.0.name

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  set {
    name = "configInline.address-pools[0].name"
    value = "default"
  }
  set {
    name = "configInline.address-pools[0].protocol"
    value = "layer2"
  }
  set {
    name  = "configInline.address-pools[0].addresses[0]"
    value = "${data.external.docker_ip_prefix.result.ip}.255.200-${data.external.docker_ip_prefix.result.ip}.255.210"
  }
}
