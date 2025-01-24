#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Determine the package manager and install curl if not present
if command -v apt-get &> /dev/null; then
    PACKAGE_MANAGER="apt-get"
    UPDATE_COMMAND="apt-get update"
    INSTALL_COMMAND="apt-get install -y"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
    UPDATE_COMMAND="dnf update -y"
    INSTALL_COMMAND="dnf install -y"
else
    echo "Unsupported package manager. Please install curl manually."
    exit 1
fi

# Update package lists
$UPDATE_COMMAND

# Check if curl is installed; if not, install it
if ! command -v curl &> /dev/null; then
    $INSTALL_COMMAND curl
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
echo "Installation successful. LibreNMS is available at: http://$IP_ADDRESS:8000"

# Remove the script after execution
rm -- "$0"
