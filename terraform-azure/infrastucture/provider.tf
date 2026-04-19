terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # Đối với CI/CD, bạn CẦN backend để lưu state trên Cloud (ví dụ Azure Blob Storage)
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatepernlam911" # Tên bạn vừa tạo thành công
    container_name       = "infrastructure"
    key                  = "infrastructure.tfstate"
  }
}

provider "azurerm" {
  features {}
}