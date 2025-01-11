###################
# BASE IMAGE
###################
FROM node:22-alpine AS base

# Thiết lập thư mục làm việc
WORKDIR /usr/src/app

# Tạo user non-root để tăng cường bảo mật
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

###################
# DEVELOPMENT
###################
FROM node:22-alpine AS development

# Thiết lập thư mục làm việc và chuyển quyền sở hữu
WORKDIR /usr/src/app
COPY --chown=node:node package*.json ./

# Cài đặt tất cả dependencies
RUN npm ci

# Sao chép mã nguồn
COPY --chown=node:node . .

# Mở cổng (nếu cần thiết)
EXPOSE 3000

# Command mặc định cho development
CMD ["npm", "run", "start:dev"]

###################
# BUILD
###################
FROM node:18-alpine AS build

# Thiết lập thư mục làm việc
WORKDIR /usr/src/app
COPY --from=development /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .

# Tạo production build
RUN npm run build

###################
# PRODUCTION
###################
FROM node:18-alpine AS production

# Thiết lập thư mục làm việc và sao chép mã đã build
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/package*.json ./

# Chỉ giữ lại các dependency cần thiết cho production
RUN npm ci --only=production && npm cache clean --force

# Chạy ứng dụng dưới quyền user non-root
USER appuser

# Mở cổng (nếu cần thiết)
EXPOSE 3000

# Command mặc định cho production
CMD ["node", "dist/main.js"]
