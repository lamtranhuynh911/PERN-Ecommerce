
# PERN STORE
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-326ce5.svg?&style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

This is a complete e-commerce system built with the PERN Stack (PostgreSQL, Express, React, Node.js). 
However, the main focus of this repository is DevOps and Infrastructure. It demonstrates how to automate CI/CD pipelines, use Infrastructure as Code (IaC), and deploy applications across Multiple Clouds (focusing on Azure) using Kubernetes.

Project is live on: [ecommerce.thltunneling.dpdns.org](ecommerce.thltunneling.dpdns.org)

Monitoring: [grafana.thltunneling.dpdns.org](grafana.thltunneling.dpdns.org) - username: guest | password: 123456

## Directory Structure

```text
PERN-Ecommerce
 |- .github/workflows    # Automated CI/CD Pipelines (GitHub Actions)
 |- client               # Frontend Source Code (React.js, Vite, Tailwind)
 |- server               # Backend API (Node.js, Express, Jest)
 |- supabase             # Database Configurations & Migrations
 |- helm                 # Kubernetes Deployment Configurations (Helm Charts)
 |- k8s                  # Raw Kubernetes Manifests
 |- terraform-azure      # Infrastructure as Code (IaC) for Azure
 |- terraform-gcp        # Infrastructure as Code (IaC) for GCP (Archive)
 |- docker-compose*.yml  # Local Environment Setups (Dev & Prod)
 |- Makefile             # Automation Shortcuts (Docker Build & Push)
```

## Screenshots

![Homepage Screen Shot](https://user-images.githubusercontent.com/51405947/104136952-a3509100-5399-11eb-94a6-0f9b07fbf1a2.png)

## Database Schema

[![ERD](https://user-images.githubusercontent.com/51405947/133893279-8872c475-85ff-47c4-8ade-7d9ef9e5325a.png)](https://dbdiagram.io/d/5fe320fa9a6c525a03bc19db)

## Containerization

1. Multi-stage Builds: Rewrote the Dockerfile for both the frontend and backend using multi-stage builds. This separates the build environment from the runtime environment, greatly reducing the final image size.

2. Security Hardening: Followed the "Least Privilege" rule. Containers are configured to run as a non-root node user instead of root, making the application much more secure against attacks.

3. Environment Parity: Used docker-compose.yml for local development (with hot-reloading) and docker-compose.prod.yml to test production settings locally before deploying.

4. Makefile Automation: Created a Makefile to automate daily tasks. Developers can easily format code, run database migrations, build Docker images, and push them to Google Artifact Registry (GAR) or Azure Container Registry (ACR) using simple make commands.

## Database Migration

* Used the Supabase CLI to manage database changes.

* All database changes (tables, roles, security policies) are saved as SQL scripts in supabase/migrations. This acts as version control for the database, making it easy to track changes or roll back if something goes wrong.

## CI/CD

Built a fully automated CI/CD pipeline using GitHub Actions to ensure code quality before it goes to Production:

**CI Pipeline (Testing & Quality):**

1. Automatically formats code using Prettier.

2. Runs static code analysis (Linting).

3. Runs Unit Tests.

**CD Pipeline (Deployment):**

1. Automatically runs database migrations.

2. Builds Docker images and tags them with the Git Commit SHA.

3. Pushes images to private registries (GAR / ACR).

4. Triggers a Helm deployment to update the application on Google Kubernetes Engine (GKE) with zero downtime.

## IaC (Azure and GCP)

* Used Terraform to automatically provision all networks, security rules, and compute clusters on both Google Cloud Platform (GCP) and Microsoft Azure.

* Modular Design: Structured the Terraform code into reusable modules (like network, aks/gke, acr/gar, keyvault). This keeps the code clean (DRY) and makes it easy to set up new environments (Dev/Staging/Prod) using .tfvars files.

## Helm 

* Managed Kubernetes deployments using Helm. Designed the charts using a smart Parent-Child structure:
Core Chart: Contains the main app resources (Deployment, Service, HPA) that work on any cloud. Wrapper Charts (Azure/GCP): Contain cloud-specific resources like Ingress Controllers and Managed Identities. Separated environment configurations cleanly into files like values-dev.yaml and values-prod.yaml.

## Monitoring

Implemented a robust, enterprise-grade monitoring stack using the `kube-prometheus-stack` Helm chart. Providing real-time observability into the Kubernetes cluster's health, pod resource consumption (CPU/Memory), and application-level metrics.

* Kubernetes / Compute Resources / Cluster.
<img width="3465" height="1971" alt="Screenshot from 2026-04-22 13-17-53" src="https://github.com/user-attachments/assets/fa1b98b0-a62c-4b69-aa50-fd2a41dae9d0" />

* Kubernetes / Compute Resources / Namespace (Pods)
<img width="3465" height="1971" alt="Screenshot from 2026-04-22 13-22-16" src="https://github.com/user-attachments/assets/7b779848-f144-4069-b740-2eeb790ffe42" />


## Security & Secret Management

* No Passwords in Code: Used the External Secrets Operator (ESO) to securely pull database passwords and API keys from Azure Key Vault and GCP Secret Manager directly into Kubernetes Pods.

* Zero Trust: Used Azure AD Pod Identity and GCP Workload Identity so the application can talk to cloud services securely without needing physical password files.

## Running the project

### Running Locally via Node.js

To run the project directly on your machine without Docker, you will need **Node.js** and **PostgreSQL** installed.
 
 #### Backend

1. Navigate to the server directory:
   ```bash
   cd server
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your environment variables by copying the example file:
   ```bash
   cp .env.example .env
   ```
   *(Update the `.env` file with your local PostgreSQL credentials).*
4. Start the development server:
   ```bash
   npm run dev
   ```

#### Frontend

1. Open a new terminal and navigate to the client directory:
   ```bash
   cd client
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your environment variables (if required):
   ```bash
   cp .env.example .env
   ```
4. Start the Vite development server:
   ```bash
   npm run dev
   ```

### Initializing the Database Schema
If you are running PostgreSQL locally, you need to create the necessary tables and seed data using the provided `init.sql` file.

1. Ensure your local PostgreSQL server is running and you have created an empty database (e.g., `ecommerce_db`).
2. Locate the initialization script at `server/config/init.sql`.
3. You can execute this script using a GUI tool like **pgAdmin** or **DBeaver**, or via the `psql` command line:
   ```bash
   psql -U your_postgres_user -d your_database_name -f server/config/init.sql
   ```

### Running via Docker Compose

#### Local Dev Container

This spins up the containers with hot-reloading enabled for active development:
```bash
docker compose up -d
```
*(To stop and remove containers, run: `docker compose down`)*

#### Local Prod Container

This simulates the real production environment, building optimized static files and serving the frontend via Nginx:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

### Provisioning Infrastructure with Terraform

We use Terraform to automate the creation of Azure resources (AKS, ACR, KeyVault) and essential Kubernetes add-ons.

#### Phase 1: Core Infrastructure
Navigate to the infrastructure directory to create the AKS cluster and ACR:
```bash
cd terraform-azure/infrastucture
terraform init
terraform plan
terraform apply -auto-approve
```

#### Phase 2: Kubernetes Components
Once the cluster is ready, set up the Nginx Ingress Controller, Cert-Manager, etc.:
```bash
# Get AKS credentials to allow Terraform to interact with the cluster
az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster-name>

cd ../k8s-components
terraform init
terraform plan
terraform apply -auto-approve
```

You'll need to manually populate secrets to the created KeyVault

### Building and Pushing Images (Makefile)

The project includes a `Makefile` to simplify building and pushing Docker images to **Azure Container Registry (ACR)**.

1. **Login to Azure CLI:**
   ```bash
   az login
   ```
2. **Login to your Azure Container Registry:**
   ```bash
   az acr login --name <your-acr-name>
   ```
3. **Build and Push using Make:**
   Ensure you are in the root directory. You can edit the `Makefile` to ensure the `ACR_NAME` variable matches yours, then run:
   ```bash
   # Push the Docker images to ACR
   make push-azure
   ```
### Deploying the Application with Helm

With the infrastructure ready and images pushed to ACR, use Helm to deploy the application.

1. Ensure your `kubectl` is pointing to your AKS cluster:
   ```bash
   az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster-name>
   ```
2. Deploy the application using the designated environment values:
   ```bash
   helm upgrade --install pernecommerce ./helm/charts/azure \
     -f ./helm/environments/azure/values-dev.yaml \
     --namespace pernecommerce-dev \
     --create-namespace
   ```
3. Deploy the monitoring stack:

   Add the Prometheus Helm repository:
   ```bash
      helm repo add prometheus-community [https://prometheus-community.github.io/helm-charts[(https://prometheus-community.github.io/helm-charts)
      helm repo update
   ```

   Deploy via Helm:
   ```bash
      helm upgrade --install kube-prom prometheus-community/kube-prometheus-stack \
      --namespace monitoring \
      --create-namespace \
      -f values-monitoring.yaml
   ```

   Retrieve the Auto-generated Grafana Admin Password:
   ```bash
      kubectl get secret --namespace monitoring kube-prom-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
   ```


### Setting up GitHub Secrets for CI/CD

To enable the automated GitHub Actions pipelines (`.github/workflows/`), you must provide Azure credentials securely. 

Go to your GitHub Repository -> **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**, and add the following:

#### 1. ACR Credentials (To push images)
Run the following commands to enable the admin user and get the credentials for your ACR:
```bash
# Enable admin user
az acr update -n <your-acr-name> --admin-enabled true

# Retrieve credentials
az acr credential show -n <your-acr-name>
```
* Add `ACR_USERNAME` (Usually the name of your registry).
* Add `ACR_PASSWORD` (Copy one of the generated passwords).

#### 2. AKS Kubeconfig (To deploy via Helm/Kubectl)
Retrieve the raw Kubeconfig file content to allow GitHub Actions to connect to your cluster:
```bash
# Fetch credentials into local kubeconfig
az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster-name>

# Output the config content
cat ~/.kube/config
```
* Add `AKS_KUBECONFIG` (Paste the **entire** output of the `cat` command, starting from `apiVersion: v1...`).



