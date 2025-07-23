#!/bin/bash

source "$(dirname "$0")/helpers.sh"

echo "$(dirname "$0")/helpers.sh"

set -euo pipefail
echo "🛠 Installing language runtimes and tools..."

PKG_MGR=$(get_pkg_mgr)

# Update and Upgrade
$PKG_MGR update && $PKG_MGR full-upgrade -y

# Some essentials
# TODO

# Install languages
./scripts/install_languages.sh

# Install tools
./scripts/install_tools.sh

# Link dotfiles
./scripts/link-dotfiles.sh

echo "✅ Language runtimes and tools installed."
