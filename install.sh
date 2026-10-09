#!/usr/bin/env bash
# Symlink the dotfiles in this repo into $HOME. Existing files are moved to *.bak.
# Usage: ./install.sh [--packages]
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "backed up $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest"
}

# Home dotfiles
for f in "$REPO"/home/.[!.]*; do
  link "$f" "$HOME/$(basename "$f")"
done

# ~/.config files
(cd "$REPO/config" && find . -type f) | while read -r f; do
  link "$REPO/config/${f#./}" "$HOME/.config/${f#./}"
done

if [ "${1:-}" = "--packages" ]; then
  sudo dnf install -y $(grep -v '^\s*$' "$REPO/packages/dnf.txt") || true
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  xargs -a "$REPO/packages/flatpak.txt" flatpak install -y flathub
fi

# Oh My Zsh + plugins used in .zshrc
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
  [ -d "$ZSH_CUSTOM/plugins/$plugin" ] || git clone --depth 1 "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
done

echo "Done."
