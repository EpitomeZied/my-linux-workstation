# my-linux-workstation

My Fedora (GNOME) workstation setup: shell, terminal, and tool configs, plus the package lists I use to rebuild the machine.

## Layout

```
home/        dotfiles that live in ~          (.zshrc, .bashrc, .gitconfig, ...)
config/      files that live in ~/.config     (ghostty, kitty, atuin, btop, glow, VS Code, spicetify, fish)
packages/    dnf.txt (user-installed packages), flatpak.txt (Flathub apps)
install.sh   symlinks everything into place
```

## Install

```sh
git clone https://github.com/EpitomeZied/my-linux-workstation.git ~/my-linux-workstation
cd ~/my-linux-workstation
./install.sh             # symlink dotfiles, install Oh My Zsh + plugins
./install.sh --packages  # also install dnf and Flatpak packages
```

Existing files are moved to `<file>.bak` before being replaced with a symlink.

## Stack

- **Shell:** zsh + Oh My Zsh (`developer` theme), zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- **Shell tools:** atuin (history), zoxide, fzf, fastfetch, mise, nvm, bun
- **Terminals:** Ghostty (Everforest palette, Geist Mono), Kitty (JetBrainsMono Nerd Font)
- **Other:** btop, glow, VS Code, Spicetify

## Updating the package lists

```sh
dnf repoquery --userinstalled --qf '%{name}\n' | sort -u > packages/dnf.txt
flatpak list --app --columns=application | sort -u > packages/flatpak.txt
```
