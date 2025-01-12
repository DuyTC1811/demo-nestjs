#!/bin/bash

sudo apt update

# Cài đặt các gói cần thiết
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Thêm khóa GPG của Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Thêm repository APT của Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Cài đặt Docker Engine
sudo apt update
sudo apt install -y docker-ce

# Kiểm tra trạng thái của dịch vụ Docker
sudo systemctl status docker

# Thêm người dùng hiện tại vào nhóm Docker
sudo usermod -aG docker ${USER}

# Áp dụng thay đổi nhóm người dùng mà không cần đăng xuất
newgrp docker

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Cấp quyền thực thi cho Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Tạo liên kết
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Kiểm tra phiên bản Docker Compose
docker-compose --version

echo "Docker and Docker Compose installation is complete!"
