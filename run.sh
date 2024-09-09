#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if not already installed
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    echo "Docker installed successfully. Please log out and log back in for group changes to take effect."
    exit 0
fi

# Install Docker Compose if not already installed
if ! command_exists docker-compose; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
fi

# Prompt for public IP or domain name
read -p "Enter your EC2 instance's public IP or domain name (leave blank for localhost): " PUBLIC_IP
PUBLIC_IP=${PUBLIC_IP:-localhost}

# Clone the original repository if it doesn't exist
if [ ! -d "Social-Media-Web-App-Mern-Stack-" ]; then
    echo "Cloning the original Social Media Web App repository..."
    git clone https://github.com/Faizan2911/Social-Media-Web-App-Mern-Stack-.git
fi

# Copy Docker-related files to the cloned repository
cp docker-compose.yml Social-Media-Web-App-Mern-Stack-/
cp nginx.conf Social-Media-Web-App-Mern-Stack-/
mkdir -p Social-Media-Web-App-Mern-Stack-/client
cp client/Dockerfile Social-Media-Web-App-Mern-Stack-/client/
mkdir -p Social-Media-Web-App-Mern-Stack-/server
cp server/Dockerfile Social-Media-Web-App-Mern-Stack-/server/

# Update package.json to include Mantine dependencies
cd Social-Media-Web-App-Mern-Stack-/client
npm install @mantine/core @mantine/hooks @mantine/form @mantine/notifications @mantine/modals
cd ../..

# Change to the project directory
cd Social-Media-Web-App-Mern-Stack-

# Update nginx.conf with the public IP
sed -i "s/server_name localhost;/server_name $PUBLIC_IP;/g" nginx.conf

# Update docker-compose.yml with the public IP
sed -i "s|REACT_APP_API_URL=http://localhost:5000|REACT_APP_API_URL=http://$PUBLIC_IP:5000|g" docker-compose.yml

# Create SSL directory if it doesn't exist
mkdir -p ssl

# Generate self-signed SSL certificate if it doesn't exist
if [ ! -f ssl/fullchain.pem ] || [ ! -f ssl/privkey.pem ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/privkey.pem -out ssl/fullchain.pem -subj "/C=US/ST=State/L=City/O=Organization/CN=$PUBLIC_IP"
fi

# Build and run Docker containers
docker-compose up -d --build

# Wait for containers to start
echo "Waiting for containers to start..."
sleep 30

# Print container status
docker-compose ps

echo "Project is now running. Access the frontend at https://$PUBLIC_IP"
echo "Access Mongo Express at http://$PUBLIC_IP:8081"