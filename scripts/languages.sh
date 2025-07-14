#!/bin/bash
set -euo pipefail

echo "🛠 Installing language runtimes and tools..."

PKG=""

if command -v apt &>/dev/null; then
	PKG="sudo apt"
elif command -v brew &>/dev/null; then
	PKG="brew"
else
	echo "❌ No supported package manager found (apt or brew required). Exiting."
	exit 1
fi

# --- Go ---
if ! command -v go &>/dev/null; then
	echo "Installing Go..."
	$PKG install -y golang
else
	echo "Go is already installed: $(go version)"
fi

# --- Python ---
if ! command -v python3 &>/dev/null; then
	echo "Installing Python3..."
	$PKG install -y python3 python3-pip
else
	echo "Python3 is already installed: $(python3 --version)"
fi

# --- uv (Python virtual environment manager) ---
if ! command -v uv &>/dev/null; then
	echo "Installing uv..."
	curl -Ls https://astral.sh/uv/install.sh | bash
else
	# Use recommended command to avoid warning
	echo "uv is already installed: $(uv self version --preview)"
fi

# --- hererocks (LuaRocks manager) ---
if ! command -v hererocks &>/dev/null; then
	echo "Installing hererocks via pip..."
	pip3 install --user hererocks
else
	echo "hererocks is already installed."
fi

# --- air (Go hot reload) ---
if ! command -v air &>/dev/null; then
	echo "Installing air..."
	go install github.com/cosmtrek/air@latest
	export PATH="$HOME/go/bin:$PATH"
else
	echo "air is already installed."
fi

echo "✅ Language runtimes and tools installed."
