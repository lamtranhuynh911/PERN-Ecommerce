# --- Stage 1: Base: Chọn base image và copy file package.json ---
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# --- Stage 2: Development: Cài tất cả các thư viện vào bao gồm cả thư viện dùng cho Dev ---
FROM base AS dev
RUN npm install
# Cài thêm nodemon global nếu cần (hoặc dùng trong devDependencies)
RUN npm install -g nodemon 
COPY . .
EXPOSE 9000
# Lệnh chạy dev, ví dụ: nodemon index.js
CMD ["npm", "run", "dev"] 

# --- Stage 3: Builder (Dọn dẹp) ---
FROM base AS builder
# Chỉ cài dependencies cần cho chạy thật (bỏ devDependencies như nodemon, eslint)
RUN npm ci --only=production
COPY . .

# --- Stage 4: Production ---
FROM node:18-alpine AS prod
WORKDIR /app
# Best practice: Không chạy container dưới quyền root để bảo mật
USER node 
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./
EXPOSE 9000
CMD ["npm", "start"]
