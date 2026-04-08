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
  
  # Best Practice: Ensure only valid environments are deployed
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

variable "db_host" {
  description = "The hostname of the Supabase PostgreSQL database"
  type        = string
}

variable "db_port" {
  description = "The port of the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "db_user" {
  description = "The database user for Supabase"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "postgres"
}

variable "app_port" {
  description = "The port the Node.js backend listens on"
  type        = number
  default     = 9000
}

variable "smtp_from" {
  description = "The 'from' email address for SMTP"
  type        = string
}

variable "smtp_user" {
  description = "The SMTP username"
  type        = string
}
variable "vite_google_client_id" {
  description = "The Google Client ID for Vite"
  type        = string
}

variable "vite_stripe_pub_key" {
  description = "The Stripe Public Key for Vite"
  type        = string
}

variable "vite_paystack_pub_key" {
  description = "The Paystack Public Key for Vite"
  type        = string
}
