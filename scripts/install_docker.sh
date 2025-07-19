#!/bin/bash
set -euo pipefail

if ! command -v docker &>/dev/null; then
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh

	# Compose
	sudo apt-get install docker-compose-plugin

	# Groups
	sudo groupadd docker
	sudo usermod -aG docker "$USER"
	newgrp docker
else
	echo "Docker is already installed."
fi
