module "cert-manager" {
  source = "./modules/cert-manager"
}

module "kong" {
  source = "./modules/kong"
  depends_on = [module.cert-manager]
}

module "admin-common" {
  source = "./modules/admin-panel"
  depends_on = [module.cert-manager]
}

module "admin-backend" {
  source = "./modules/admin-panel/backend"
  depends_on = [module.admin-common]
}

module "admin-frontend" {
  source = "./modules/admin-panel/frontend"
  depends_on = [module.admin-common]
}

module "argo" {
  source = "./modules/argo"
  depends_on = [module.cert-manager]
}