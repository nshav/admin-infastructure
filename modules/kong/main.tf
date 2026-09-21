
resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/namespace.yaml"))
}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = file("${path.module}/cluster_issuer.yaml")
}

resource "helm_release" "kong_ingress" {
  atomic           = true
  name             = var.ic_name
  repository       = "https://charts.konghq.com"
  chart            = "ingress"
  namespace        = "kong"
  create_namespace = false

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  depends_on = [kubernetes_manifest.namespace]
}