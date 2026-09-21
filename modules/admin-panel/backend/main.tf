resource "kubernetes_manifest" "database-pvc" {
  manifest = yamldecode(file("${path.module}/storage.yaml"))
}

resource "kubernetes_manifest" "backend" {
  manifest = yamldecode(file("${path.module}/backend.yaml"))
}

resource "kubernetes_manifest" "service-backend" {
  manifest = yamldecode(file("${path.module}/service.yaml"))
}