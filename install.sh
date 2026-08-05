#!/bin/bash
# ╔══════════════════════════════════════════════════════════╗
# ║       Obsidian Glow — Automated Install Script          ║
# ╚══════════════════════════════════════════════════════════╝
#
# This script symlinks all config files and installs dependencies.
# Run from the repo root: ./install.sh
#
# Flags:
#   --copy    Copy files instead of symlinking (portable but no auto-updates)
#   --help    Show usage

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
LINK_CMD="ln -sf"

# ── Parse flags ───────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --copy) LINK_CMD="cp -f" ;;
        --help)
            echo "Usage: ./install.sh [--copy]"
            echo "  --copy   Copy files instead of symlinking"
            exit 0
            ;;
    esac
done

# ── Colors ────────────────────────────────────────────────
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[2m'
RESET='\033[0m'

info()  { echo -e "${CYAN}[INFO]${RESET}  $1"; }
ok()    { echo -e "${GREEN}[OK]${RESET}    $1"; }
warn()  { echo -e "${RED}[WARN]${RESET}  $1"; }
header(){ echo -e "\n${PURPLE}══ $1 ══${RESET}"; }

# ── Check distro ─────────────────────────────────────────
header "Obsidian Glow — Installer"
echo -e "${DIM}Repo: ${REPO_DIR}${RESET}"

if ! command -v pacman &>/dev/null; then
    warn "This script is designed for Arch Linux (pacman)."
    warn "You'll need to install dependencies manually on other distros."
    read -rp "Continue anyway? [y/N] " yn
    [[ "$yn" =~ ^[Yy]$ ]] || exit 1
fi

# ── Install dependencies ─────────────────────────────────
header "Installing Dependencies"

DEPS=(
    hyprland
    hyprlock
    hypridle
    hyprpolkitagent
    waybar
    kitty
    thunar
    dunst
    playerctl
    cava
    python-gobject
    gtk-layer-shell
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    pipewire
    wireplumber
    pavucontrol
    ttf-jetbrains-mono-nerd
    inter-font
    starship
    eza
    bat
    fastfetch
    podman
    distrobox
    mpv
)

AUR_DEPS=(
    hyprlauncher
    awww
    bibata-cursor-theme
)

info "Installing official packages..."
sudo pacman -S --needed --noconfirm "${DEPS[@]}" 2>/dev/null && ok "Official packages installed" || warn "Some packages may have failed"

# Check for AUR helper
AUR_HELPER=""
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
fi

if [[ -n "$AUR_HELPER" ]]; then
    info "Installing AUR packages via ${AUR_HELPER}..."
    $AUR_HELPER -S --needed --noconfirm "${AUR_DEPS[@]}" 2>/dev/null && ok "AUR packages installed" || warn "Some AUR packages may have failed"
else
    warn "No AUR helper found (yay/paru). Install these manually:"
    for pkg in "${AUR_DEPS[@]}"; do
        echo -e "  ${DIM}• ${pkg}${RESET}"
    done
fi

# Optional: Feishin (Navidrome client)
info "Feishin (Navidrome client) is optional for the music widget."
if [[ -n "$AUR_HELPER" ]]; then
    read -rp "Install feishin-bin? [y/N] " yn
    [[ "$yn" =~ ^[Yy]$ ]] && $AUR_HELPER -S --needed --noconfirm feishin-bin
fi

# ── Deploy configs ────────────────────────────────────────
header "Deploying Configurations"

deploy() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    
    # Backup existing config
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        info "Backing up existing: ${dest} → ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi
    
    $LINK_CMD "$src" "$dest"
    ok "$(basename "$dest")"
}

# Hyprland
deploy "$REPO_DIR/config/hypr/hyprland.lua"      "$HOME/.config/hypr/hyprland.lua"
deploy "$REPO_DIR/config/hypr/hypridle.conf"      "$HOME/.config/hypr/hypridle.conf"
deploy "$REPO_DIR/config/hypr/hyprlock.conf"      "$HOME/.config/hypr/hyprlock.conf"
deploy "$REPO_DIR/config/hypr/hyprlauncher.conf"  "$HOME/.config/hypr/hyprlauncher.conf"

# Waybar
deploy "$REPO_DIR/config/waybar/config.jsonc"     "$HOME/.config/waybar/config.jsonc"
deploy "$REPO_DIR/config/waybar/style.css"        "$HOME/.config/waybar/style.css"

# Cava
deploy "$REPO_DIR/config/cava/config_ags"         "$HOME/.config/cava/config_ags"

# Music Widget
deploy "$REPO_DIR/config/music_widget/music_widget.py"   "$HOME/.config/music_widget/music_widget.py"
deploy "$REPO_DIR/config/music_widget/toggle_music.sh"   "$HOME/.config/music_widget/toggle_music.sh"
chmod +x "$HOME/.config/music_widget/toggle_music.sh"

# Starship
deploy "$REPO_DIR/config/starship/starship.toml"  "$HOME/.config/starship.toml"

# Fastfetch
deploy "$REPO_DIR/config/fastfetch/config.jsonc"  "$HOME/.config/fastfetch/config.jsonc"

# Kitty
deploy "$REPO_DIR/config/kitty/kitty.conf"        "$HOME/.config/kitty/kitty.conf"

# Bashrc
deploy "$REPO_DIR/.bashrc"                        "$HOME/.bashrc"
deploy "$REPO_DIR/.blerc"                         "$HOME/.blerc"

# MPV
if [ -d "$REPO_DIR/config/mpv" ]; then
    deploy "$REPO_DIR/config/mpv" "$HOME/.config/mpv"
fi

# Thunar
if [ -d "$REPO_DIR/config/Thunar" ]; then
    deploy "$REPO_DIR/config/Thunar" "$HOME/.config/Thunar"
fi

# Wallpaper
mkdir -p "$HOME/Pictures/wallpapers"
deploy "$REPO_DIR/wallpapers/obsidian_glow.jpg"   "$HOME/Pictures/wallpapers/obsidian_glow.jpg"

# ── Set cursor theme ──────────────────────────────────────
header "Finishing Up"

if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
    ok "GTK settings applied"
fi

# ── Done ──────────────────────────────────────────────────
echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${PURPLE}║${RESET}  ${GREEN}✔ Obsidian Glow installed successfully!${RESET}               ${PURPLE}║${RESET}"
echo -e "${PURPLE}╠══════════════════════════════════════════════════════════╣${RESET}"
echo -e "${PURPLE}║${RESET}  Log out and back in to Hyprland to apply.             ${PURPLE}║${RESET}"
echo -e "${PURPLE}║${RESET}  Press ${CYAN}SUPER + N${RESET} to toggle the music widget.          ${PURPLE}║${RESET}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${RESET}"
