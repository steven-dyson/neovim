#!/bin/bash

source "$(dirname "$0")/helpers.sh"

set -euo pipefail
echo "🛠 Installing language runtimes and tools..."

PKG_MGR=$(get_pkg_mgr)

# Update and Upgrade
$PKG_MGR update && $PKG_MGR full-upgrade -y

# Some essentials
# TODO
$PKG_MGR install unzip fc-cache
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/0xProto.zip
unzip 0xProto.zip -d 0xProto
mkdir -p "$HOME/.local/share/fonts"
cp 0xProto/*.ttf "$HOME/.local/share/fonts/"
# fc-cache -fv

# Install languages
./scripts/install_languages.sh

# Link dotfiles
./scripts/link-dotfiles.sh

# Install tools
./scripts/install_tools.sh

echo "✅ Language runtimes and tools installed."
