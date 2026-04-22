resource "azurerm_container_registry" "acr" {
  name                = "${var.registry_name}registry"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = var.sku 
  admin_enabled       = true  
}