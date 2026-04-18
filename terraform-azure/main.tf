# ==============================================================================
# ROOT MAIN.TF - AZURE INFRASTRUCTURE FOR PERN ECOMMERCE
# ==============================================================================

# 1. Local Values for Naming Conventions
locals {
  project_prefix = "pernecommerce"
}

# ==============================================================================
# MODULE DECLARATIONS
# ==============================================================================

# 2. Base Module (Resource Group)
module "base" {
  source       = "./modules/base"
  
  project_name = local.project_prefix
  environment  = var.environment
  location     = var.location
}

# 3. Azure Container Registry (ACR) Module
module "acr" {
  source              = "./modules/acr"
  
  registry_name       = "${local.project_prefix}acr${var.environment}" 
  rg_name = module.base.rg_name
  rg_location            = module.base.rg_location
  sku                 = "Basic"
}

# 4. Azure Kubernetes Service (AKS) Module
module "aks" {
  source              = "./modules/aks"
  
  cluster_name        = "${local.project_prefix}-aks-${var.environment}"
  dns_prefix          = "${local.project_prefix}-k8s"
  
  rg_name = module.base.rg_name
  rg_location            = module.base.rg_location
  acr_id              = module.acr.acr_id
  
  node_count          = var.node_count
  vm_size             = "Standard_B2s" 
}

# 5. Azure Key Vault Module
module "keyvault" {
  source              = "./modules/keyvault"
  
  keyvault_name       = "${local.project_prefix}kv${var.environment}"
  resource_group_name = module.base.rg_name
  location            = module.base.rg_location
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = module.keyvault.keyvault_id  
  tenant_id    = data.azurerm_client_config.current.tenant_id
  
  object_id    = module.aks.kubelet_identity_object_id 

  secret_permissions = [
    "Get", "List"
  ]
}