# modules/aks/outputs.tf

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  description = "Kubernetes cluster configuration object"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0]
  sensitive   = true
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}