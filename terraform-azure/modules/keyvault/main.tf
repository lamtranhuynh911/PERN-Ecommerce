data "azurerm_client_config" "current" {}

# 1. Create the Key Vault (The empty safe)
resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false 

  sku_name = "standard"

  # Access Policy: Grant the Terraform runner (You) permissions to manage secrets
  # so you can inject them manually later via CLI.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }
}

# DO NOT add azurerm_key_vault_secret resources here.