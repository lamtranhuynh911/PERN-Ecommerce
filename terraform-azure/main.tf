# 1. Tạo Resource Group (Bắt buộc trong Azure)
resource "azurerm_resource_group" "pern_rg" {
  name     = "pern-ecommerce-rg"
  location = "Southeast Asia" # Tương đương asia-southeast1
}

# 2. Tạo Azure Container Registry (ACR) để lưu Docker Image
resource "azurerm_container_registry" "pern_acr" {
  name                = "pernecommerceacr" # Tên ACR phải viết liền, không ký tự đặc biệt, và là DUY NHẤT trên toàn cầu
  resource_group_name = azurerm_resource_group.pern_rg.name
  location            = azurerm_resource_group.pern_rg.location
  sku                 = "Basic" # Gói rẻ nhất cho test
  admin_enabled       = true
}

# 3. Tạo Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "pern_aks" {
  name                = "pern-aks-cluster"
  location            = azurerm_resource_group.pern_rg.location
  resource_group_name = azurerm_resource_group.pern_rg.name
  dns_prefix          = "pern-aks"

  # Cấu hình Node Pool (Worker nodes)
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # Dòng máy ảo giá rẻ, hợp cho việc học
  }

  # Azure yêu cầu khai báo identity (SystemAssigned là dễ nhất)
  identity {
    type = "SystemAssigned"
  }
}