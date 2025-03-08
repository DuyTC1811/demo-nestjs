# Build stage
FROM node:22-alpine AS build
WORKDIR /usr/src/app
COPY . .
RUN npm ci
RUN npm run build

# Production stage
FROM node:22-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Chạy ứng dụng dưới quyền user non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Mở cổng (nếu cần thiết)
EXPOSE 3000

# Command mặc định cho production
CMD ["node", "dist/main.js"]
