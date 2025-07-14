# dev-bootstrap

Personal setup for bootstrapping my development environment across machines.

Includes my dotfiles, config folders, and setup scripts for Neovim, tmux, Ghostty,
and other tools I regularly use.

---

## 🪄 Usage

1. Clone the repo:  
   git clone <https://github.com/steven-dyson/dev-bootstrap.git> ~/dev-bootstrap

2. Run the dotfile linker:  
   Might need to chmod
   ~/dev-bootstrap/scripts/link-dotfiles.sh  
   (Prompts before overwriting any existing config files.)

3. (Optional) Set up TPM for tmux:  
   ~/dev-bootstrap/scripts/setup-tmux.sh

4. Inside tmux:  
   Press `Ctrl + b`, then `I` to install plugins  
   Press `Ctrl + b`, then `r` to reload the config

---

## Notes

- Dotfiles are symlinked into `~/.config` or `$HOME`
- TPM installs plugins to `~/.tmux/plugins`
- Secrets (certs, keys, etc.) are stored in Bitwarden — never committed
- Idempotent scripts: safe to re-run anytime

---

## ⚠️ Disclaimer

This is a personal repo intended for my own systems.  
I take no responsibility for what these scripts or configs do to your system.  
Read the code before running anything.
