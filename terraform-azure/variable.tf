# ==============================================================================
# INFRASTRUCTURE VARIABLES
# ==============================================================================

variable "location" {
  description = "The Azure Region where all resources will be created"
  type        = string
  default     = "southeastasia"
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "node_count" {
  description = "Number of worker nodes for the AKS cluster"
  type        = number
  default     = 2
}

# ==============================================================================
# APPLICATION CONFIGURATION VARIABLES (NON-SENSITIVE)
# ==============================================================================

variable "db_port" {
  description = "The port of the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "app_port" {
  description = "The port the Node.js backend listens on"
  type        = number
  default     = 9000
}
