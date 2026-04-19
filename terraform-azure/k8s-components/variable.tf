variable "cluster_name" {
  type        = string
  description = "Cluster name of the AKS cluster to connect to"
  default     = "pernecommerce-aks-dev"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name containing the AKS cluster"
  default     = "pernecommerce-rg-dev"
}