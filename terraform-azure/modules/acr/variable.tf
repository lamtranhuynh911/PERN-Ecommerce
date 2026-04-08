variable "registry_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}

variable "rg_location" {
  description = "Azure region where the ACR will be created"
  type        = string
}

variable "sku" {
  description = "The SKU name of the container registry (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}