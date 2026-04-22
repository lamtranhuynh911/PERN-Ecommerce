resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix          = "${var.dns_prefix}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_b2as_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}