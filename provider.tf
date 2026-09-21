terraform {
  backend "gcs" {
    bucket = "support-tfstates"
    prefix = "infra"
  }
}


data "google_client_config" "default" {}
data "google_container_cluster" "test_cluster" {
  name     = "nsha-cluster"
  location = "us-central1"
  project  = "poc-cloud-nodes"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.test_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = "https://${data.google_container_cluster.test_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.test_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}