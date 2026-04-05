# providers.tf
# Terraform block to specify required providers and versions
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Provider with your project and region
provider "google" {
  project = var.project_id
  region  = var.region
}