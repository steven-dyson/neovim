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

# arg1: package manager (e.g., apt)
# arg2: command to check (e.g., go)
# arg3: package name to install (e.g., golang), empty string if not used
handle_install() {
	if ! command -v "$2" &>/dev/null; then
		read -rp "Do you want to install $2? (y/N) " answer
		if [[ "${answer,,}" == "y" ]]; then
			echo "🟢 Installing $2..."
			if [[ -n "$4" ]]; then
				eval "$4"
			else
				$1 install -y "$3"
			fi

			if [[ -n "$5" ]]; then
				ensure_path "$5"
			fi
		else
			echo "❌ Skipping installation of $2"
		fi
	else
		echo "📦 $2 is already installed"
	fi
}

set -euo pipefail
echo "🛠 Installing language runtimes and tools..."

PKG=$(get_pkg_mgr)

#Git
handle_install "$PKG" git git-all "" ""

# Go
GO_TARGET=1.24.5
handle_install "$PKG" go "" "./scripts/install_go.sh $GO_TARGET" "$HOME/go/bin"

# Air (Go Hot Reload)
handle_install "$PKG" air "" "go install github.com/cosmtrek/air@latest" ""

# Python
handle_install "$PKG" python3 python3 "" ""

# UV (Python Package Manager)
handle_install "$PKG" uv "" "curl -Ls https://astral.sh/uv/install.sh | bash" ""

# Docker
handle_install "$PKG" docker "" "./scripts/install_docker.sh" ""

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
handle_install "{$PKG}" nvm "" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash" ""

# PNPM
handle_install "$PKG" pnpm "" "curl -fsSL https://get.pnpm.io/install.sh | sh -" ""

# TODO: Remaining to setup
# NVIM
# Lazygit
# grep / fzf
# Lua / hererocks / luarocks
# Postgres

echo "✅ Language runtimes and tools installed."
