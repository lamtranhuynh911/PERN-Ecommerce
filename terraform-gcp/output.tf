output "kubernetes_cluster_name" {
  value       = google_container_cluster.pern_cluster.name
  description = "The name of the provisioned GKE cluster"
}

output "artifact_registry_url" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.pern_docker_repo.repository_id}"
  description = "The base URL for pushing Docker images"
}