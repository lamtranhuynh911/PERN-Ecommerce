data "azurerm_client_config" "current" {}

module "base" {
  source         = "./modules/base"
  environment    = var.environment
  location       = var.location
  project_name   = var.project_prefix
}

# Azure Container Registry (ACR) Module
module "acr" {
  source              = "./modules/acr"
  
  registry_name       = "${var.project_prefix}acr${var.environment}" 
  rg_name = module.base.rg_name
  rg_location            = module.base.rg_location
  sku                 = "Basic"
}

# Azure Kubernetes Service (AKS) Module
module "aks" {
  source              = "./modules/aks"
  
  cluster_name        = "${var.project_prefix}-aks-${var.environment}"
  dns_prefix          = "${var.project_prefix}-k8s"
  
  rg_name = module.base.rg_name
  rg_location            = module.base.rg_location
  acr_id              = module.acr.acr_id
  
  node_count          = 1
  vm_size             = "Standard_B2s_v2" 
}

# Azure Key Vault Module
module "keyvault" {
  source              = "./modules/keyvault"
  
  keyvault_name       = "${var.project_prefix}kv${var.environment}"
  resource_group_name = module.base.rg_name
  location            = module.base.rg_location
}
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.aks.kubelet_identity_object_id

  secret_permissions = ["Get", "List"]
}