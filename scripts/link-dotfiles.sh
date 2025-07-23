#!/bin/bash
set -euo pipefail

FORCE=${FORCE:-false}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
DOTFILES="$REPO_ROOT/dotfiles"

link() {
	local src=$1
	local dest=$2

	if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$src" ]; then
		echo "✅ $dest already correctly linked"
		return
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		if [[ "$FORCE" != true ]]; then
			read -rp "❗ $dest exists. Overwrite with $src? [y/N] " confirm
			if [[ "$confirm" != [yY] ]]; then
				echo "⏭️ Skipping $dest"
				return
			fi
		else
			echo "⚠️ Forcing overwrite of $dest"
		fi
	fi

	mkdir -p "$(dirname "$dest")"
	ln -sfn "$src" "$dest"
	echo "✅ Linked $src → $dest"
}

echo "🔗 Linking dotfiles..."

link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES/tmux" "$HOME/.config/tmux"

echo "🎉 Dotfile linking complete!"
