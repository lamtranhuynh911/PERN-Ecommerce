variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "node_count" {
  description = "Number of worker nodes in the default pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Size of the virtual machines for nodes"
  type        = string
  default     = "standard_b2as_v2"
}

variable "acr_id" {
  description = "ID of the ACR to grant pull permissions"
  type        = string
}