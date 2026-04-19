terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  # Backend configuration to store state in Azure Blob Storage
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatepernlam911" # Tên bạn vừa tạo thành công
    container_name       = "tfstate"           # Tên container bạn vừa tạo
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  # Lấy host và credentials từ chính resource AKS bạn vừa khai báo
  host                   = azurerm_kubernetes_cluster.pernecommerce-aks-dev.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.pernecommerce-aks-dev.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.pernecommerce-aks-dev.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.pernecommerce-aks-dev.kube_config.0.cluster_ca_certificate)
}