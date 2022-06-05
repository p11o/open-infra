
data "external" "udp_cluster_ip" {
  depends_on = [helm_release.nginx_udp]
  program = [
    "${path.module}/scripts/cluster-ip.sh", helm_release.nginx_udp.namespace
  ]
}


resource "kubernetes_config_map_v1" "coredns" {
  metadata {
    name = "coredns"
    namespace = "kube-system"
  }

  data = {
    "Corefile" = <<EOT
infra.local:53 {
    errors
    cache 30
    forward . ${data.external.udp_cluster_ip.result.clusterIP}
}
.:53 {
    errors
    health {
        lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
        ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf {
        max_concurrent 1000
    }
    cache 30
    loop
    reload
    loadbalance
}
EOT
  }
}
