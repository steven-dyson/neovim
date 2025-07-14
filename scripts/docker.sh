#!/bin/bash
set -euo pipefail

echo "🚢 Installing Docker..."

if ! command -v docker &>/dev/null; then
	# Remove old versions if any
	sudo apt remove -y docker docker-engine docker.io containerd runc || true

	sudo apt update

	sudo apt install -y \
		ca-certificates \
		curl \
		gnupg \
		lsb-release

	# Add Docker’s official GPG key
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

	# Add Docker repo
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

	sudo apt update

	# Install docker packages
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

	sudo systemctl enable docker.service
	sudo systemctl start docker.service

	# Add current user to docker group
	sudo usermod -aG docker "$USER"
	newgrp docker

	echo "✅ Docker installed! You might need to log out and back in."
else
	echo "Docker is already installed."
fi
