# modules/aks/outputs.tf

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  description = "Kubernetes cluster configuration object"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0]
  sensitive   = true
}