resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/namespace.yaml"))
}

resource "helm_release" "argocd" {
  atomic           = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = false

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}

resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("${path.module}/ingress.yaml"))
}


resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/applicationset.yaml"))
}

# resource "kubectl_manifest" "agents_appset" {
#   yaml_body  = file("${path.module}/applicationset.yaml")
#   depends_on = [helm_release.argocd]
# }