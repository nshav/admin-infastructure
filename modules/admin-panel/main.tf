resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/namespace.yaml"))
}

resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("${path.module}/ingress_kong.yaml"))
  depends_on = [kubernetes_manifest.namespace]
}