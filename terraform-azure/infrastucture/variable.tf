variable "environment" {
  type        = string
  description = "Environment (dev, stage, prod)"
}

variable "location" {
  type        = string
  default     = "southeastasia"
  description = "Azure Region"
}

variable "project_prefix" {
  type        = string
  default     = "pernecommerce"
}

variable "cluster_name" {
  type        = string
  default     = "pernecommerce-aks"
}