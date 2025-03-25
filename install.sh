#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Install Docker
bash <(curl -fsSL https://get.docker.com)

# Download necessary files from GitHub
wget -q https://raw.githubusercontent.com/skippybossx/librenms_docker/main/.env
wget -q https://raw.githubusercontent.com/skippybossx/librenms_docker/main/docker-compose.yml
wget -q https://raw.githubusercontent.com/skippybossx/librenms_docker/main/librenms.env
wget -q https://raw.githubusercontent.com/skippybossx/librenms_docker/main/msmtpd.env

# Start LibreNMS using Docker Compose
docker compose up -d

# Get the server's IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Display success message with access URL
echo "Installation successful. LibreNMS is available at: http://$IP_ADDRESS"
