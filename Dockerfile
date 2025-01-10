# Stage 1: Build
# Sử dụng Node.js phiên bản 22 làm image cơ sở cho giai đoạn build
FROM node:22 AS builder

# Đặt thư mục làm việc trong container là /usr/src/app
WORKDIR /usr/src/app

# Sao chép các tệp package.json và package-lock.json (nếu có) vào container
COPY package*.json ./

# Cài đặt tất cả các dependency cần thiết để build dự án
RUN npm install

# Sao chép toàn bộ mã nguồn vào thư mục làm việc trong container
COPY . .

# Chạy lệnh build dự án, thường là tạo phiên bản sản phẩm (production-ready)
RUN npm run build

# Stage 2: Production
# Sử dụng Node.js phiên bản 22-alpine (nhẹ hơn) cho môi trường production
FROM node:22-alpine

# Đặt thư mục làm việc trong container là /usr/src/app
WORKDIR /usr/src/app

# Sao chép thư mục dist từ giai đoạn builder (chứa mã nguồn đã build xong)
COPY --from=builder /usr/src/app/dist ./dist

# Sao chép file package.json và package-lock.json vào container
COPY package*.json ./

# Cài đặt các dependency chỉ cần thiết cho môi trường production
RUN npm ci --only=production

# Mở cổng 3000 để ứng dụng có thể nhận request từ bên ngoài
EXPOSE 3000

# Chạy ứng dụng bằng lệnh node với entry point là dist/main
CMD ["node", "dist/main"]
