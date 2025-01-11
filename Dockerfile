# Base image
FROM node:22-alpine

# Thiết lập thư mục làm việc
WORKDIR /usr/src/app

# Copy file package.json và package-lock.json để cài đặt dependencies
COPY package*.json ./

# Cài đặt dependencies chỉ dành cho production
RUN npm ci --only=production && npm cache clean --force

# Sao chép mã nguồn vào image
COPY . .

# Chạy ứng dụng dưới quyền user non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Mở cổng (nếu cần thiết)
EXPOSE 3000

# Command mặc định cho production
CMD ["node", "dist/main.js"]
