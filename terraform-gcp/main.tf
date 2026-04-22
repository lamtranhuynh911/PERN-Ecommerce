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
resource "google_container_cluster" "pern_cluster" {
  name     = "pern-gke-cluster"
  location = var.region

  # Enable Autopilot mode
  enable_autopilot = true

  # Networking
  network    = "default"
  subnetwork = "default"

  # Disable deletion protection for development/testing environments
  deletion_protection = false 
}

