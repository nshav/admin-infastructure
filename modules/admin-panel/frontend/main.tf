resource "kubernetes_manifest" "frontend" {
  manifest = yamldecode(file("${path.module}/frontend.yaml"))
}

resource "kubernetes_manifest" "service-frontend" {
  manifest = yamldecode(file("${path.module}/service.yaml"))
}