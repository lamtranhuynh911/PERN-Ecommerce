# --- Stage 1: Base ---
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# --- Stage 2: Development (Dành cho Local Docker Compose) ---
FROM base AS dev
RUN npm install --legacy-peer-deps
COPY . .
# Vite default port
EXPOSE 3000 

CMD ["npm", "start"]

# --- Stage 3: Builder (Chuẩn bị cho Prod) ---
FROM base AS builder

RUN npm ci --only-production# Cài đặt chính xác theo package-lock.json
COPY . .
RUN npm run build # Tạo thư mục /dist

# --- Stage 4: Production (Dành cho GKE) ---
FROM nginxinc/nginx-unprivileged:alpine AS prod
# Copy file build từ stage builder sang thư mục nginx
USER root

# 1. Copy build artifacts
# Ensure the destination is writable by the nginx user (ID 101) later
COPY --from=builder /app/dist /usr/share/nginx/html

# 2. Setup env.sh script
COPY env.sh /docker-entrypoint.d/env.sh
RUN chmod +x /docker-entrypoint.d/env.sh

# 3. Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 4. CRITICAL: Grant permission to nginx user to write env-config.js at runtime
# The env.sh script needs to write to this directory.
RUN chown -R 101:101 /usr/share/nginx/html

# Switch back to non-root user (nginx user ID is 101 in this image)
USER 101

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]