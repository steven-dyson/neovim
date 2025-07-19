#!/bin/bash
set -euo pipefail

if ! command -v docker &>/dev/null; then
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh

	# Compose
	sudo apt-get install docker-compose-plugin

	# Groups
	getent group docker >/dev/null || sudo groupadd docker
	CURRENT_USER=$(whoami)
	sudo usermod -aG docker "$CURRENT_USER"
else
	echo "Docker is already installed."
fi
