#!/bin/bash

get_pkg_mgr() {
	if command -v apt &>/dev/null; then
		echo "sudo apt"
	elif command -v brew &>/dev/null; then
		echo "brew"
	else
		echo "❌ No supported package manager found (apt or brew required). Exiting."
		exit 1
	fi
}

# arg1: directory to add to PATH
ensure_path() {
	if [[ ":$PATH:" != *":$1:"* ]]; then
		if ! grep -q "export PATH=\"$1:\$PATH\"" ~/.bashrc; then
			echo "🔧 Adding $1 to PATH in .bashrc"
			echo "export PATH=\"$1:\$PATH\"" >>~/.bashrc
		else
			echo "⚠️  $1 already referenced in .bashrc"
		fi
		export PATH="$1:$PATH"
	else
		echo "✅ $1 already in PATH"
	fi
}

set_alias() {
	local to=$1
	local from=$2

	target="$HOME/.bash_aliases"

	if ! test -f "$target"; then
		touch "$target"
	fi

	if ! grep -q "alias $from=" "$target"; then
		echo "alias $from=\"$to\"" >>"$target"
	fi
}

# arg1: package manager (e.g., apt)
# arg2: command to check (e.g., go)
# arg3: package name to install (e.g., golang), empty string if not used
handle_install() {
	local name=$1
	local fnc=$2
	local cmd=$3

	if ! command -v "$cmd" &>/dev/null; then
		read -rp "🤔 Do you want to install $name? (y/N) " answer
		if [[ "${answer,,}" == "y" ]]; then
			echo "🟢 Installing $name..."
			"$fnc"
		else
			echo "❌ Skipping installation of $name"
		fi
	else
		echo "📦 $name is already installed"
	fi
}

set -euo pipefail
echo "🛠 Installing language runtimes and tools..."

PKG_MGR=$(get_pkg_mgr)

# Update and Upgrade
sudo apt update && sudo apt full-upgrade -y

# Go
install_go() {
	GO_TARGET=1.24.5
	./scripts/install_go.sh $GO_TARGET
	ensure_path "/usr/local/go/bin"
	ensure_path '$HOME/go/bin'
}
handle_install "Go" install_go go

# Air (Go Hot Reload)
install_air() {
	go install github.com/air-verse/air@latest
}
handle_install "Air" install_air air

# Python
install_python() {
	"$PKG_MGR" install python3
	set_alias "python" "python3"
	set_alias "py" "python3"
}
handle_install "Python" install_python python3

# UV (Python Package Manager)
install_uv() {
	curl -Ls https://astral.sh/uv/install.sh | bash

	# Always ensure correct path is in PATH
	ensure_path "$HOME/.local/bin"

	local uv_env="$HOME/.local/bin/env"
	if [[ -f "$uv_env" ]]; then
		echo "🔁 Sourcing uv env config from $uv_env"
		# shellcheck source=/root/.local/bin/env
		source "$uv_env"
	else
		echo "⚠️  uv env file not found at $uv_env"
	fi
}
handle_install "uv" install_uv uv

# Docker
install_docker() {
	./scripts/install_docker.sh
}
handle_install "Docker" install_docker docker

# NVM
install_nvm() {
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

	if [ -z "${XDG_CONFIG_HOME-}" ]; then
		export NVM_DIR="${HOME}/.nvm"
	else
		export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
	fi

	if [ -s "$NVM_DIR/nvm.sh" ]; then
		. "$NVM_DIR/nvm.sh"
	fi

	nvm install 20
	nvm alias default 20
}
handle_install "NVM" install_nvm nvm

# PNPM
install_pnpm() {
	curl -fsSL https://get.pnpm.io/install.sh | sh -
	set_alias "pn" "pnpm"
}
handle_install "PNPM" install_pnpm pnpm

# TODO: Remaining to setup
# NVIM
# Lazygit
# grep / fzf
# Lua / hererocks / luarocks
# Postgres

echo "✅ Language runtimes and tools installed."
