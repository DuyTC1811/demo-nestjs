# Sử dụng Node.js phiên bản nhẹ cho môi trường production
FROM node:22-alpine

# Đặt thư mục làm việc trong container
WORKDIR /usr/src/app

# Sao chép mã nguồn đã build (dist) vào container
COPY ..

# Sao chép file package.json và package-lock.json để cài đặt dependency
COPY package*.json ./

# Cài đặt chỉ các dependency cần thiết cho môi trường production
RUN npm ci --only=production

# Mở cổng 3000 để ứng dụng sẵn sàng nhận request
EXPOSE 3000

# Chạy ứng dụng
CMD ["node", "dist/main"]
