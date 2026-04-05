# main.tf

# ------------------------------------------------------------------------------
# 1. Google Artifact Registry (GAR) to store Docker Images
# ------------------------------------------------------------------------------
resource "google_artifact_registry_repository" "pern_docker_repo" {
  repository_id = "pern-repo"
  location      = var.region
  format        = "DOCKER"
  description   = "Docker repository for PERN stack frontend and backend images"
}

# ------------------------------------------------------------------------------
# 2. Google Kubernetes Engine (GKE) Cluster
# ------------------------------------------------------------------------------
# We use GKE Autopilot here as it is the modern best practice. 
# Google manages the nodes, and you only pay for the Pods' CPU/RAM requests.
resource "google_container_cluster" "pern_cluster" {
  name     = "pern-gke-cluster"
  location = var.region

  # Enable Autopilot mode
  enable_autopilot = true

  # Networking
  network    = "default"
  subnetwork = "default"

  # Disable deletion protection for development/testing environments
  # WARNING: Set to true for Production to prevent accidental destruction
  deletion_protection = false 
}

