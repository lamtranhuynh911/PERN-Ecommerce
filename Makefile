# ==========================================
# 1. GENERAL CONFIG
# ==========================================
TAG=$(shell git rev-parse --short HEAD)

# --- Image names ---
IMG_BE_LOCAL=pern-ecommerce-server
IMG_FE_LOCAL=pern-ecommerce-client

REGION=asia-southeast1
PROJECT_ID=sapient-depot-482908-d3
REPO_NAME=docker-registry
GCP_REGISTRY=$(REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO_NAME)

ACR_NAME=pernecommerceacrdevregistry
ACR_REGISTRY=$(ACR_NAME).azurecr.io

# ==========================================
# 2. BUILD
# ==========================================
.PHONY: all build-be build-fe build-all

all: build-all

build-be:
	@echo "[Backend] Building LOCAL image: $(TAG)..."
	docker build -t $(IMG_BE_LOCAL):$(TAG) -t $(IMG_BE_LOCAL):latest ./server

build-fe:
	@echo "[Frontend] Building LOCAL image: $(TAG)..."
	docker build -t $(IMG_FE_LOCAL):$(TAG) -t $(IMG_FE_LOCAL):latest ./client

build-all: build-be build-fe
	@echo "Build ALL done locally!"

# ==========================================
# 3. PUSH - GOOGLE CLOUD
# ==========================================
.PHONY: push-gcp push-be-gcp push-fe-gcp

push-be-gcp: build-be
	@echo "Tagging & Pushing Backend to GCP..."
	docker tag $(IMG_BE_LOCAL):$(TAG) $(GCP_REGISTRY)/$(IMG_BE_LOCAL):$(TAG)
	docker tag $(IMG_BE_LOCAL):latest $(GCP_REGISTRY)/$(IMG_BE_LOCAL):latest
	docker push $(GCP_REGISTRY)/$(IMG_BE_LOCAL):$(TAG)
	docker push $(GCP_REGISTRY)/$(IMG_BE_LOCAL):latest

push-fe-gcp: build-fe
	@echo "Tagging & Pushing Frontend to GCP..."
	docker tag $(IMG_FE_LOCAL):$(TAG) $(GCP_REGISTRY)/$(IMG_FE_LOCAL):$(TAG)
	docker tag $(IMG_FE_LOCAL):latest $(GCP_REGISTRY)/$(IMG_FE_LOCAL):latest
	docker push $(GCP_REGISTRY)/$(IMG_FE_LOCAL):$(TAG)
	docker push $(GCP_REGISTRY)/$(IMG_FE_LOCAL):latest

push-gcp: push-be-gcp push-fe-gcp
	@echo "Pushed to Google Cloud!"

# ==========================================
# 4. PUSH - AZURE CLOUD
# ==========================================
.PHONY: push-azure push-be-azure push-fe-azure

push-be-azure: build-be
	@echo "Tagging & Pushing Backend to Azure..."
	docker tag $(IMG_BE_LOCAL):$(TAG) $(ACR_REGISTRY)/$(IMG_BE_LOCAL):$(TAG)
	docker tag $(IMG_BE_LOCAL):latest $(ACR_REGISTRY)/$(IMG_BE_LOCAL):latest
	docker push $(ACR_REGISTRY)/$(IMG_BE_LOCAL):$(TAG)
	docker push $(ACR_REGISTRY)/$(IMG_BE_LOCAL):latest

push-fe-azure: build-fe
	@echo "Tagging & Pushing Frontend to Azure..."
	docker tag $(IMG_FE_LOCAL):$(TAG) $(ACR_REGISTRY)/$(IMG_FE_LOCAL):$(TAG)
	docker tag $(IMG_FE_LOCAL):latest $(ACR_REGISTRY)/$(IMG_FE_LOCAL):latest
	docker push $(ACR_REGISTRY)/$(IMG_FE_LOCAL):$(TAG)
	docker push $(ACR_REGISTRY)/$(IMG_FE_LOCAL):latest

push-azure: push-be-azure push-fe-azure
	@echo "Pushed to Azure!"