# ==========================================
# 1. CẤU HÌNH CHUNG
# ==========================================
PROJECT_ID=sapient-depot-482908-d3
REGION=asia-southeast1
REPO_NAME=docker-registry
TAG=$(shell git rev-parse --short HEAD)

# Định nghĩa tên Image đầy đủ
# Backend
IMG_BE=$(REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO_NAME)/pern-ecommerce-server
# Frontend
IMG_FE=$(REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO_NAME)/pern-ecommerce-client

# ==========================================
# 2. CÁC LỆNH (TARGETS)
# ==========================================

# Khai báo .PHONY để tránh lỗi nếu trong folder có file trùng tên với lệnh
.PHONY: all build-be build-fe push-be push-fe

# Lệnh mặc định khi gõ 'make' -> sẽ build cả 2
all: build-all

# --- BACKEND ---
build-be:
	@echo "🐘 [Backend] Building image: $(TAG)..."
	# Lưu ý: tham số cuối là ./backend (trỏ vào thư mục backend)
	docker build -t $(IMG_BE):$(TAG) -t $(IMG_BE):latest ./server

push-be: build-be
	@echo "🚀 [Backend] Pushing to GAR..."
	docker push $(IMG_BE):$(TAG)
	docker push $(IMG_BE):latest

# --- FRONTEND ---
build-fe:
	@echo "⚛️  [Frontend] Building image: $(TAG)..."
	# Lưu ý: Frontend thường cần Build Argument cho biến môi trường (như API URL)
	# Nếu dùng Vite/NextJS, biến này sẽ được 'bake' vào code tĩnh
	docker build \
		-t $(IMG_FE):$(TAG) -t $(IMG_FE):latest ./client

push-fe: build-fe
	@echo "🚀 [Frontend] Pushing to GAR..."
	docker push $(IMG_FE):$(TAG)
	docker push $(IMG_FE):latest

# --- TỔNG HỢP ---
build-all: build-be build-fe
	@echo "✅ Build ALL done!"

push-all: push-be push-fe
	@echo "✅ Push ALL done!"

# --- TIỆN ÍCH ---
# Lệnh để in ra tag hiện tại (check xem đang ở commit nào)
check-tag:
	@echo "Current Tag will be: $(TAG)"