# PERN E-commerce Platform - Helm Deployment Guide

This directory contains Helm charts for deploying the PERN E-commerce Platform to both Azure Kubernetes Service (AKS) and Google Kubernetes Engine (GKE).

## Directory Structure

```
helm/
├── Chart.yaml                    # Root chart metadata
├── values.yaml                   # Base values (shared across all deployments)
├── charts/
│   ├── core/                     # Platform-agnostic core templates
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── backend-deployment.yaml
│   │       ├── backend-service.yaml
│   │       ├── frontend-deployment.yaml
│   │       ├── frontend-service.yaml
│   │       ├── configmap.yaml
│   │       ├── serviceaccount.yaml
│   │       ├── namespace.yaml
│   │       └── _helpers.tpl
│   ├── azure/                    # Azure-specific templates
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── ingress.yaml      # Azure Application Gateway
│   │       ├── pod-identity.yaml # Azure AD Pod Identity
│   │       ├── secretstore.yaml  # Secret Store for Key Vault
│   │       ├── externalsecret.yaml
│   │       └── certificate.yaml
│   └── gcp/                     # GCP-specific templates
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── ingress.yaml      # GKE Ingress with Cloud Load Balancer
│           ├── certificate.yaml  # GKE Managed Certificate
│           ├── secretstore.yaml  # Secret Store for Secret Manager
│           ├── externalsecret.yaml
│           └── secret-store.yaml
└── environments/                # Environment-specific values
    ├── azure/
    │   ├── values-dev.yaml
    │   └── values-prod.yaml
    └── gcp/
        ├── values-dev.yaml
        └── values-prod.yaml
```

## Architecture

### Core Chart (`core/`)
Contains **platform-agnostic** Kubernetes resources:
- Backend API Deployment
- Frontend Application Deployment
- Services for both
- ConfigMap for application configuration
- ServiceAccounts for RBAC

### Azure Chart (`azure/`)
Azure-specific deployment components:
- **Ingress**: Uses Azure Application Gateway ingress controller
- **Pod Identity**: Azure AD Pod Identity for Workload Identity
- **SecretStore**: External Secrets integration with Azure Key Vault
- **Certificate Management**: TLS certificate provisioning

### GCP Chart (`gcp/`)
GCP-specific deployment components:
- **Ingress**: GKE Ingress with Cloud Load Balancer
- **ManagedCertificate**: GKE managed SSL certificates
- **SecretStore**: External Secrets integration with GCP Secret Manager
- **Workload Identity**: GCP Workload Identity binding

## Deployment Instructions

### Prerequisites

1. **kubectl** configured to access your cluster
2. **Helm 3.x** installed
3. Cloud provider CLI configured:
   - Azure: `az` CLI for AKS
   - GCP: `gcloud` CLI for GKE
4. **External Secrets Operator** installed in your cluster
5. Appropriate RBAC permissions

### GCP Deployment

#### Development Environment

```bash
# Add GCP-specific values and deploy
helm install pern helm/charts/gcp \
  --values helm/values.yaml \
  --values helm/environments/gcp/values-dev.yaml \
  --namespace pern-dev \
  --create-namespace \
  --dependency-update
```

#### Production Environment

```bash
# Add GCP-specific values with production configuration
helm install pern helm/charts/gcp \
  --values helm/values.yaml \
  --values helm/environments/gcp/values-prod.yaml \
  --namespace pern-prod \
  --create-namespace \
  --dependency-update
```

### Azure Deployment

#### Development Environment

```bash
# Add Azure-specific values and deploy
helm install pern helm/charts/azure \
  --values helm/values.yaml \
  --values helm/environments/azure/values-dev.yaml \
  --namespace pern-dev \
  --create-namespace \
  --dependency-update
```

#### Production Environment

```bash
# Add Azure-specific values with production configuration
helm install pern helm/charts/azure \
  --values helm/values.yaml \
  --values helm/environments/azure/values-prod.yaml \
  --namespace pern-prod \
  --create-namespace \
  --dependency-update
```

## Configuration

### Important Values to Customize

Before deploying, update these in the environment-specific values files:

#### GCP
- `gcp.projectId`: Your GCP project ID
- `gcp.projectNumber`: Your GCP project number
- `gcp.cluster.name`: Your GKE cluster name
- `gcp.cluster.location`: GKE cluster location
- `backend.image.repository`: Your Artifact Registry image URL
- `frontend.image.repository`: Your Artifact Registry image URL
- `global.domain`: Your domain name

#### Azure
- `azure.resourceGroup`: Your resource group name
- `azure.cluster.name`: Your AKS cluster name
- `azure.keyVault.name`: Your Key Vault name
- `azure.managedIdentity.clientId`: Managed Identity client ID
- `azure.managedIdentity.tenantId`: Azure tenant ID
- `backend.image.repository`: Your ACR image URL
- `frontend.image.repository`: Your ACR image URL
- `global.domain`: Your domain name

### Application Configuration

Update these in environment-specific values:
- `config.googleClientId`: Google OAuth client ID
- `config.stripePubKey`: Stripe publishable key
- `config.paystackPubKey`: Paystack public key
- `config.apiBaseUrl`: Backend API base URL

## Secret Management

### GCP (Secret Manager)
1. Store secrets in GCP Secret Manager
2. External Secrets operator automatically syncs to Kubernetes Secret
3. Reference: `secrets.externalSecrets.secrets`

### Azure (Key Vault)
1. Store secrets in Azure Key Vault
2. Pod Identity enables Workload Identity authentication
3. External Secrets operator syncs secrets to Kubernetes Secret
4. Reference: `secrets.externalSecrets.secrets`

## Upgrades

### Upgrade Chart

```bash
# GCP
helm upgrade pern helm/charts/gcp \
  --values helm/values.yaml \
  --values helm/environments/gcp/values-prod.yaml

# Azure
helm upgrade pern helm/charts/azure \
  --values helm/values.yaml \
  --values helm/environments/azure/values-prod.yaml
```

### Rollback

```bash
# Rollback to previous release
helm rollback pern [REVISION_NUMBER]
```

## Monitoring

### View Deployed Resources

```bash
# List all Helm releases
helm list -n pern-prod

# Get release values
helm get values pern -n pern-prod

# View manifest
helm get manifest pern -n pern-prod
```

### Check Pod Status

```bash
kubectl get pods -n pern-prod
kubectl describe pod <pod-name> -n pern-prod
kubectl logs <pod-name> -n pern-prod
```

## Troubleshooting

### External Secrets Not Syncing

**GCP:**
```bash
# Check Workload Identity binding
gcloud iam service-accounts list
gcloud iam service-accounts get-iam-policy [SERVICE-ACCOUNT-EMAIL]

# Check ExternalSecret status
kubectl describe externalsecret app-secrets-external -n pern-prod
```

**Azure:**
```bash
# Check Pod Identity status
kubectl describe azureidentity pern-workload-prod -n pern-prod

# Check ExternalSecret status
kubectl describe externalsecret app-secrets-external -n pern-prod
```

### Ingress Not Working

**GCP:**
```bash
kubectl get ingress -n pern-prod
kubectl describe ingress pern-ingress -n pern-prod

# Check service endpoints
kubectl get endpoints backend-svc -n pern-prod
```

**Azure:**
```bash
kubectl get ingress -n pern-prod
kubectl describe ingress pern-ingress -n pern-prod

# Check Application Gateway
az network application-gateway list -g pern-ecommerce-rg-prod
```

## Best Practices

1. **Use specific image tags** in production (not `latest`)
2. **Define resource requests and limits** for proper scheduling
3. **Keep secrets in native secret managers** (Key Vault, Secret Manager)
4. **Use multiple replicas** for high availability
5. **Enable health checks** for liveness and readiness probes
6. **Implement NetworkPolicies** for security
7. **Monitor and log** using cloud provider monitoring solutions
8. **Test upgrades** in dev/staging before production

## Support

For issues or questions:
1. Check cloud provider documentation
2. Review External Secrets Operator docs
3. Check Kubernetes events: `kubectl describe`
4. Check pod logs: `kubectl logs`

## License

[Your License Here]
