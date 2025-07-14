#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/dev-bootstrap/dotfiles"

link() {
	local src=$1
	local dest=$2

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		read -rp "❗ $dest already exists. Overwrite with $src? [y/N] " confirm
		if [[ "$confirm" != [yY] ]]; then
			echo "⏭️  Skipping $dest"
			return
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
