terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatepernlam911"
    container_name       = "infrastructure"
    key                  = "infrastructure.tfstate"
  }
}

provider "azurerm" {
  features {}
}