#!/bin/bash

source ./helpers.sh

set -euo pipefail
echo "🛠 Installing language runtimes and tools..."

PKG_MGR=$(get_pkg_mgr)

# Update and Upgrade
$PKG_MGR update && $PKG_MGR full-upgrade -y

# Some essentials
# TODO

# Install languages
./install_languages.sh

# Install tools
./install_tools.sh

# Link dotfiles
./link-dotfiles.sh

echo "✅ Language runtimes and tools installed."
