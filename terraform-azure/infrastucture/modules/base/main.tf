# ==============================================================================
# BASE MODULE - MAIN.TF
# ==============================================================================

# Create a Resource Group for the entire infrastructure
resource "azurerm_resource_group" "main" {
  # Naming convention: project prefix + resource type + environment
  name     = "${var.project_name}-rg-${var.environment}"
  location = var.location

  # Best Practice: Always apply tags to your base resources for billing and management
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}