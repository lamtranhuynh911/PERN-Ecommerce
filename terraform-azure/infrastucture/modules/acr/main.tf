resource "azurerm_container_registry" "acr" {
  name                = "${var.registry_name}registry" # Tên ACR không được có dấu gạch ngang
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = var.sku # Gói rẻ nhất cho môi trường Dev/Test
  admin_enabled       = true    # Bật để dễ dàng test kéo image lúc đầu
}