# --- Stage 1: Base
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# --- Stage 2: Development
FROM base AS dev
RUN npm install
COPY . .
EXPOSE 9000
CMD ["npm", "run", "dev"] 

# --- Stage 3: Builder
FROM base AS builder
RUN npm ci --only=production
COPY . .

# --- Stage 4: Production
FROM node:18-alpine AS prod
WORKDIR /app
USER node 
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./
EXPOSE 9000
CMD ["npm", "start"]
