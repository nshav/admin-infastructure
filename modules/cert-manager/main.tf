resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/namespace.yaml"))
}

resource "helm_release" "cert_manager" {
  atomic     = true
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = var.cm_name
  create_namespace = false

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  depends_on = [kubernetes_manifest.namespace]
}
