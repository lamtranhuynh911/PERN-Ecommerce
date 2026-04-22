# Create a Resource Group for the entire infrastructure
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}