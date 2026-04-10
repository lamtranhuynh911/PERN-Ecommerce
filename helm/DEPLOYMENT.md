# Deployment Guide for PERN E-commerce Platform

## Quick Start

### GCP Deployment
```bash
# Development
helm install pern helm/charts/gcp \
  -f helm/values.yaml \
  -f helm/environments/gcp/values-dev.yaml \
  -n pern-dev --create-namespace

# Production  
helm install pern helm/charts/gcp \
  -f helm/values.yaml \
  -f helm/environments/gcp/values-prod.yaml \
  -n pern-prod --create-namespace
```

### Azure Deployment
```bash
# Development
helm install pern helm/charts/azure \
  -f helm/values.yaml \
  -f helm/environments/azure/values-dev.yaml \
  -n pern-dev --create-namespace

# Production
helm install pern helm/charts/azure \
  -f helm/values.yaml \
  -f helm/environments/azure/values-prod.yaml \
  -n pern-prod --create-namespace
```

## Architecture Overview

The Helm structure is organized into three main layers:

### 1. **Root Chart** (`helm/`)
- Entry point for all deployments
- Contains base values shared across all clouds and environments
- Declares dependency on the `core` chart

### 2. **Core Chart** (`helm/charts/core/`)
Platform-agnostic templates used by both Azure and GCP:
- Backend API Deployment
- Frontend Deployment  
- Services (ClusterIP for both)
- ConfigMap (application environment variables)
- ServiceAccounts (RBAC)
- Namespace creation

### 3. **Cloud-Specific Charts** (`helm/charts/azure/` and `helm/charts/gcp/`)

Each cloud provider chart depends on `core` and adds:

**Azure (`azure/`):**
- Application Gateway Ingress
- Azure Pod Identity & Identity Binding
- Azure Key Vault SecretStore
- TLS Certificate management

**GCP (`gcp/`):**
- GKE Ingress with Cloud Load Balancer
- GKE Managed Certificate
- GCP Secret Manager SecretStore
- Workload Identity binding

### 4. **Environment Values** (`helm/environments/`)
Override values for different environments:
- `values-dev.yaml`: Development configuration (1 replica, dev resources)
- `values-prod.yaml`: Production configuration (3 replicas, prod resources, specific versions)

## Key Improvements from Original Structure

❌ **Before (Issues):**
- Azure chart had GCP-specific templates (GKE ManagedCertificate, GCP Secret Manager)
- GCP chart also contained GCP-specific config mixed with platform references
- No clear separation between core app and cloud-specific resources
- Values were duplicated across charts
- No environment-specific configurations

✅ **After (Fixed):**
- **Clear separation of concerns**: Core app logic vs cloud-specific resources
- **True platform independence**: `core/` works identically for both Azure and GCP
- **Proper dependencies**: Azure and GCP charts declare `core` as a dependency
- **Centralized values**: Shared values in root, cloud-specific in each chart
- **Environment support**: Dev/Prod configurations keep resources appropriately scaled
- **Consistent labels**: All resources tagged with proper Kubernetes labels
- **Proper RBAC**: ServiceAccounts for both backend and frontend
- **Health checks**: Liveness and readiness probes configured

## Configuration Checklist

Before deploying, customize these values:

### Global
- [ ] `global.domain`: Your production domain
- [ ] `backend.image.repository`: Your image registry URL
- [ ] `frontend.image.repository`: Your image registry URL

### GCP
- [ ] `gcp.projectId`: Your GCP project ID
- [ ] `gcp.cluster.name`: Your GKE cluster name
- [ ] `gcp.cluster.location`: Cluster region/zone
- [ ] `gcp.serviceAccount.email`: Workload Identity service account

### Azure
- [ ] `azure.resourceGroup`: Your resource group name
- [ ] `azure.cluster.name`: Your AKS cluster name
- [ ] `azure.keyVault.name`: Your Key Vault name
- [ ] `azure.managedIdentity.clientId`: Pod Identity client ID
- [ ] `azure.managedIdentity.tenantId`: Azure tenant ID

### Application
- [ ] `config.googleClientId`: Google OAuth credentials
- [ ] `config.stripePubKey`: Stripe public key
- [ ] `config.paystackPubKey`: Paystack public key

## Deploying to Different Clusters

### List available Helm releases
```bash
helm list -A
```

### Switch between clusters
```bash
# Local cluster (example)
kubectl config use-context docker-desktop

# GCP cluster
gcloud container clusters get-credentials pern-gke-prod --zone asia-southeast1-a

# Azure cluster
az aks get-credentials --resource-group pern-ecommerce-rg-prod --name pern-aks-prod
```

### Deploy to specific cluster
```bash
# Verify current context
kubectl config current-context

# Deploy
helm install pern helm/charts/gcp -f helm/environments/gcp/values-prod.yaml -n pern-prod --create-namespace
```

## Managing Secrets

### GCP Secret Manager
```bash
# Create secret
gcloud secrets create pern-api-keys --data-file=keys.json

# Reference in values-gcp-prod.yaml:
# secrets.externalSecrets.secrets[].key: "pern-api-keys"
```

### Azure Key Vault
```bash
# Create secret
az keyvault secret set --vault-name pern-keyvault --name api-keys --file keys.json

# Reference in values-azure-prod.yaml:
# secrets.externalSecrets.secrets[].key: "api-keys"
```

## Monitoring Deployments

```bash
# Watch deployment status
kubectl rollout status deployment/backend -n pern-prod
kubectl rollout status deployment/frontend -n pern-prod

# Check events
kubectl get events -n pern-prod --sort-by='.lastTimestamp'

# View pod logs
kubectl logs -f deployment/backend -n pern-prod
kubectl logs -f deployment/frontend -n pern-prod
```

## Next Steps

1. Update all placeholder values in environment files
2. Ensure External Secrets Operator is installed
3. Configure cloud provider credentials/identities
4. Deploy to dev environment first for testing
5. Verify all resources are running
6. Deploy to production with production values
