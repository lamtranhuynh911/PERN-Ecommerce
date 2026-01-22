# --- Stage 1: Base ---
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# --- Stage 2: Development (Dành cho Local Docker Compose) ---
FROM base AS dev
RUN npm install
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
FROM nginx:alpine AS prod
# Copy file build từ stage builder sang thư mục nginx
COPY --from=builder /app/dist /usr/share/nginx/html
# Copy file cấu hình nginx để proxy api call về back-end (cần file nginx.conf)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
