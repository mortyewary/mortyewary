#!/usr/bin/env bash

# --- System Update ---
echo ">>> Updating system..."
sudo pacman -Syu --noconfirm

# --- Essential Packages ---
ESSENTIAL_PACKAGES=(
  git base-devel gcc clang cmake make pkgconf
  python python-pip python-virtualenv
  nodejs npm
  rustup
  docker docker-compose
  alacritty code
  thunar thunar-archive-plugin thunar-volman tumbler
  wl-clipboard imv
  zsh zsh-syntax-highlighting zsh-autosuggestions
  htop tmux unzip wget curl man-db bash-completion
  openssh ufw pacman-contrib reflector
  btrfs-assistant
)

echo ">>> Installing essential packages..."
sudo pacman -S --needed --noconfirm "${ESSENTIAL_PACKAGES[@]}"

# --- Rust Setup ---
echo ">>> Setting up Rust..."
rustup install stable
rustup default stable

# --- Docker Setup ---
echo ">>> Enabling Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# --- Default Editor Setup ---
echo ">>> Setting default editor to Code - OSS..."
if ! grep -q "export EDITOR=code" "$HOME/.zshrc"; then
  echo 'export EDITOR=code' >> "$HOME/.zshrc"
else
  echo ">>> Default editor already set in .zshrc — skipping"
fi

# --- Python venv check ---
echo ">>> Ensuring Python venv tools..."
python -m venv --help >/dev/null 2>&1 || echo "⚠️  Python venv seems broken!"

# --- Hyprland Keybinds ---
echo ">>> Checking Hyprland keybinds..."
KEYBINDS_FILE="$HOME/.config/hypr/hyprland.conf"
mkdir -p "$(dirname "$KEYBINDS_FILE")"

if ! grep -q 'bind = $mainMod, Return, exec, alacritty' "$KEYBINDS_FILE" 2>/dev/null; then
  echo 'bind = $mainMod, Return, exec, alacritty' >> "$KEYBINDS_FILE"
fi
if ! grep -q 'bind = $mainMod, C, exec, code' "$KEYBINDS_FILE" 2>/dev/null; then
  echo 'bind = $mainMod, C, exec, code' >> "$KEYBINDS_FILE"
fi
echo ">>> Keybinds ensured."

# --- Snapper Config ---
echo ">>> Configuring Snapper..."
sudo snapper -c root set-config TIMELINE_CREATE=yes
sudo snapper -c root set-config TIMELINE_CLEANUP=yes
sudo snapper -c root set-config TIMELINE_MIN_AGE=1800
sudo snapper -c root set-config TIMELINE_LIMIT_HOURLY=3
sudo snapper -c root set-config TIMELINE_LIMIT_DAILY=7
sudo snapper -c root set-config TIMELINE_LIMIT_WEEKLY=1

# --- BTRFS Balance ---
echo ">>> Running BTRFS balance..."
sudo btrfs balance start -dusage=50 -musage=50 /

# --- Zsh Alias for Dev Refresh ---
if ! grep -q "alias devsetup=" "$HOME/.zshrc"; then
  echo "alias devsetup='$HOME/setup-dev.sh'" >> "$HOME/.zshrc"
  echo ">>> Added 'devsetup' alias to .zshrc"
fi

# --- Final Notes ---
echo ""
echo "✅ Development environment setup complete!"
echo "🔹 Please reboot for Docker group changes to take effect."
echo "🔹 Snapper is installed via CachyOS Helper and already pre-configured."
echo "   This script only adjusted retention (3 hourly, 7 daily, 1 weekly)."
echo "   You can review and fine-tune settings in Btrfs Assistant."
