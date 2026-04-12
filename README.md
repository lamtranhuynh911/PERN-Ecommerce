
# PERN STORE

This is a complete e-commerce system built with the PERN Stack (PostgreSQL, Express, React, Node.js). 
However, the main focus of this repository is DevOps and Infrastructure. It demonstrates how to automate CI/CD pipelines, use Infrastructure as Code (IaC), and deploy applications across Multiple Clouds (GCP and Azure) using Kubernetes.

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

## Security & Secret Management

* No Passwords in Code: Used the External Secrets Operator (ESO) to securely pull database passwords and API keys from Azure Key Vault and GCP Secret Manager directly into Kubernetes Pods.

* Zero Trust: Used Azure AD Pod Identity and GCP Workload Identity so the application can talk to cloud services securely without needing physical password files.