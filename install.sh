#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Update system based on distro
update_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                apt update && apt upgrade -y
                ;;
            centos|rhel)
                yum update -y
                ;;
            fedora)
                dnf upgrade --refresh -y
                ;;
            alpine)
                apk update && apk upgrade
                ;;
            *)
                echo "Unsupported or unknown distro: $ID"
                ;;
        esac
    else
        echo "Cannot detect Linux distribution."
    fi
}

update_system

# Install Docker
# bash <(curl -fsSL https://get.docker.com)

# sleep 1

# Download necessary files from GitHub
wget -q https://raw.githubusercontent.com/MazMarco/librenms_docker/main/.env
wget -q https://raw.githubusercontent.com/MazMarco/librenms_docker/main/docker-compose.yml
wget -q https://raw.githubusercontent.com/MazMarco/librenms_docker/main/librenms.env
wget -q https://raw.githubusercontent.com/MazMarco/librenms_docker/main/msmtpd.env

sleep 1

# Start LibreNMS using Docker Compose
# docker compose up -d

# sleep 1

# Get the server's IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Spinner function
spin() {
    local -a marks=( '/' '-' '\' '|' )
    local i=0
    local end=$((SECONDS + 30))
    while [ $SECONDS -lt $end ]; do
        printf "\rPlease wait... ${marks[i]}"
        i=$(( (i + 1) % 4 ))
        sleep 0.1
    done
    printf "\rDone!            \n"
}

spin

# Display success message with access URL
echo -e "\n✅ Installation complete!"
echo "🌐 Access LibreNMS at: http://$IP_ADDRESS"
echo "⏳ If it's not loading yet, please wait a moment – the containers may still be initializing..."
