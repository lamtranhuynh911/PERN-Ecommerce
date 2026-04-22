# ==============================================================================
# ROOT OUTPUTS.TF
# ==============================================================================

output "resource_group_name" {
  value = module.base.rg_name
}

output "acr_login_server" {
  description = "The URL of the Container Registry"
  value       = module.acr.login_server
}

output "aks_cluster_name" {
  value = module.aks.kubernetes_cluster_name
}

output "aks_kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}