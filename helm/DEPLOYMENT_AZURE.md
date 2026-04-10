# Helm Deployment Guide - Azure

This guide explains how to deploy the PERN E-commerce application to Azure using Helm while maintaining alignment with Terraform infrastructure.

## Prerequisites

- Terraform infrastructure deployed via `terraform-azure/` (creates AKS, ACR, Key Vault, etc.)
- `helm` CLI installed
- `kubectl` configured with Azure credentials
- Azure CLI logged in

## Naming Conventions

All resources follow the Terraform naming scheme:

- **Project Prefix**: `pernecommerce`
- **Cluster**: `pernecommerce-aks-{environment}` (dev, staging, prod)
- **ACR**: `pernecommerce{environment}.azurecr.io` (e.g., `pernecommerceacrdev.azurecr.io`)
- **Key Vault**: `pernecommerce-kv-{environment}`
- **Managed Identity**: `pernecommerce-identity-{environment}`
- **Resource Group**: `pernecommerce-rg` (shared across environments)
- **Location**: `southeastasia`

## Directory Structure

```
helm/
├── Chart.yaml                    # Root Helm chart metadata
├── values.yaml                   # Base values (cloud-agnostic defaults)
├── charts/
│   ├── core/                     # Shared K8s templates (platform-agnostic)
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/            # Deployments, services, configmaps, etc.
│   │
│   ├── azure/                    # Azure cloud provider resources
│   │   ├── Chart.yaml
│   │   ├── values.yaml           # Base Azure configs
│   │   └── templates/            # AppGateway, KeyVault, Pod Identity
│   │
│   └── gcp/                      # GCP cloud provider resources
│       ├── Chart.yaml
│       ├── values.yaml           # Base GCP configs
│       └── templates/
│
└── environments/                 # Environment-specific overrides
    └── azure/
        ├── values-dev.yaml       # Dev environment (1 replica, low resources)
        ├── values-staging.yaml   # Staging environment (2 replicas, medium resources)
        └── values-prod.yaml      # Production (3 replicas, high resources)
```

## Deployment Steps

### 1. Get AKS Credentials

After Terraform deployment, authenticate with your AKS cluster:

```bash
# Dev environment
az aks get-credentials --resource-group pernecommerce-rg \
  --name pernecommerce-aks-dev \
  --overwrite-existing

# Staging environment
az aks get-credentials --resource-group pernecommerce-rg \
  --name pernecommerce-aks-staging \
  --overwrite-existing

# Production environment
az aks get-credentials --resource-group pernecommerce-rg \
  --name pernecommerce-aks-prod \
  --overwrite-existing
```

### 2. Add Log In to ACR

Configure kubectl to pull images from your Azure Container Registry:

```bash
# Dev
az aks update -n pernecommerce-aks-dev -g pernecommerce-rg \
  --attach-acr pernecommerceacrdev

# Staging
az aks update -n pernecommerce-aks-staging -g pernecommerce-rg \
  --attach-acr pernecommerceacrstaging

# Production
az aks update -n pernecommerce-aks-prod -g pernecommerce-rg \
  --attach-acr pernecommerceacrprod
```

### 3. Deploy with Helm

Deploy using environment-specific values:

```bash
# Development
helm install pern-dev ./helm \
  -f ./helm/environments/azure/values-dev.yaml \
  --namespace pernecommerce-dev \
  --create-namespace

# Staging
helm install pern-staging ./helm \
  -f ./helm/environments/azure/values-staging.yaml \
  --namespace pernecommerce-staging \
  --create-namespace

# Production
helm install pern-prod ./helm \
  -f ./helm/environments/azure/values-prod.yaml \
  --namespace pernecommerce-prod \
  --create-namespace
```

### 4. Upgrade Deployment

```bash
# Dev
helm upgrade pern-dev ./helm \
  -f ./helm/environments/azure/values-dev.yaml

# Staging
helm upgrade pern-staging ./helm \
  -f ./helm/environments/azure/values-staging.yaml

# Production
helm upgrade pern-prod ./helm \
  -f ./helm/environments/azure/values-prod.yaml
```

### 5. Verify Deployment

```bash
# Check Helm releases
helm list -n pernecommerce-dev
helm list -n pernecommerce-staging
helm list -n pernecommerce-prod

# Check pod status
kubectl get pods -n pernecommerce-dev
kubectl get pods -n pernecommerce-staging
kubectl get pods -n pernecommerce-prod

# Check services
kubectl get svc -n pernecommerce-dev
kubectl get svc -n pernecommerce-staging
kubectl get svc -n pernecommerce-prod

# Check Ingress
kubectl get ingress -n pernecommerce-dev
kubectl get ingress -n pernecommerce-staging
kubectl get ingress -n pernecommerce-prod
```

## Configuration Management

### Environment-Specific Settings

Each environment has specific configurations:

| Setting | Dev | Staging | Prod |
|---------|-----|---------|------|
| Backend Replicas | 1 | 2 | 3 |
| Frontend Replicas | 1 | 2 | 3 |
| CPU Request (BE) | 100m | 150m | 250m |
| Memory Request (BE) | 256Mi | 384Mi | 512Mi |
| Domain | dev-ecommerce.thltunneling.dpdns.org | staging-ecommerce.thltunneling.dpdns.org | ecommerce.thltunneling.dpdns.org |

### Secrets Management

Secrets are managed via Azure Key Vault and injected using the External Secrets Operator:

```bash
# Verify External Secrets integration
kubectl get externalsecrets -n pernecommerce-dev
kubectl get secretstore -n pernecommerce-dev
kubectl get secrets -n pernecommerce-dev
```

## Integration with Terraform Outputs

Extract Terraform outputs to configure Helm values:

```bash
# Get ACR login server
terraform output acr_login_server

# Get AKS cluster name
terraform output aks_cluster_name

# Get resource group name
terraform output resource_group_name
```

Use these outputs to verify that Helm chart values match your Terraform deployment.

## Troubleshooting

### Pods not pulling images

Check ACR authentication:

```bash
kubectl describe pod <pod-name> -n pernecommerce-dev
kubectl logs <pod-name> -n pernecommerce-dev
```

Ensure the managed identity has ACR pull permissions.

### Secrets not loading

Verify External Secrets Operator is running:

```bash
kubectl get deployment -n external-secrets-system
kubectl logs -n external-secrets-system -l app.kubernetes.io/name=external-secrets
```

### Ingress not accessible

Check Application Gateway status:

```bash
kubectl describe ingress frontend-ingress -n pernecommerce-prod
kubectl logs -n kube-system -l app=ingress-appgw
```

## Values Override Examples

### Custom image tag

```bash
helm install pern-dev ./helm \
  -f ./helm/environments/azure/values-dev.yaml \
  --set backend.image.tag=custom-tag \
  --set frontend.image.tag=custom-tag
```

### Scale replicas

```bash
helm upgrade pern-prod ./helm \
  -f ./helm/environments/azure/values-prod.yaml \
  --set backend.replicaCount=4 \
  --set frontend.replicaCount=4
```

## References

- [Helm Documentation](https://helm.sh/docs/)
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [External Secrets Operator](https://external-secrets.io/)
- [Kubernetes Application Gateway Ingress Controller](https://azure.github.io/application-gateway-kubernetes-ingress/)
