# Lấy thông tin tài khoản hiện tại
data "azurerm_client_config" "current" {}

module "base" {
  source         = "./modules/base"
  environment    = var.environment
  location       = var.location
  project_prefix = var.project_prefix
}

module "aks" {
  source              = "./modules/aks"
  environment         = var.environment
  location            = var.location
  project_prefix      = var.project_prefix
  resource_group_name = module.base.resource_group_name
  vnet_subnet_id      = module.base.aks_subnet_id
}

module "keyvault" {
  source              = "./modules/keyvault"
  environment         = var.environment
  location            = var.location
  project_prefix      = var.project_prefix
  resource_group_name = module.base.resource_group_name
}

module "acr" {
  source              = "./modules/acr"
  environment         = var.environment
  location            = var.location
  project_prefix      = var.project_prefix
  resource_group_name = module.base.resource_group_name
}

# Cấp quyền cho AKS đọc mật khẩu từ Key Vault
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.aks.kubelet_identity_object_id

  secret_permissions = ["Get", "List"]
}