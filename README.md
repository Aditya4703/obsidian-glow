<div align="center">

# 🔮 Obsidian Glow

**A dark, minimal, violet & cyan Hyprland rice for Arch Linux**

*Glassmorphic aesthetics · Cava music visualizer · Starship prompt · Premium animations*

![Hyprland](https://img.shields.io/badge/Hyprland-0.46+-a855f7?style=for-the-badge&logo=wayland&logoColor=white)
![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-06b6d4?style=for-the-badge)

</div>

---

## 🎨 Color Palette

| Role | Hex | Preview |
|------|-----|---------|
| Background | `#0d0d0d` | ![#0d0d0d](https://placehold.co/15x15/0d0d0d/0d0d0d.png) |
| Surface | `#1a1a2e` | ![#1a1a2e](https://placehold.co/15x15/1a1a2e/1a1a2e.png) |
| Surface 2 | `#16213e` | ![#16213e](https://placehold.co/15x15/16213e/16213e.png) |
| Accent Violet | `#a855f7` | ![#a855f7](https://placehold.co/15x15/a855f7/a855f7.png) |
| Accent Cyan | `#06b6d4` | ![#06b6d4](https://placehold.co/15x15/06b6d4/06b6d4.png) |
| Text | `#e4e4e7` | ![#e4e4e7](https://placehold.co/15x15/e4e4e7/e4e4e7.png) |
| Text Dim | `#a1a1aa` | ![#a1a1aa](https://placehold.co/15x15/a1a1aa/a1a1aa.png) |
| Urgent/Red | `#f43f5e` | ![#f43f5e](https://placehold.co/15x15/f43f5e/f43f5e.png) |
| Success/Green | `#10b981` | ![#10b981](https://placehold.co/15x15/10b981/10b981.png) |
| Warning/Amber | `#f59e0b` | ![#f59e0b](https://placehold.co/15x15/f59e0b/f59e0b.png) |

---

## 📦 What's Included

```
obsidian-glow/
├── .bashrc                       # Enhanced bash with aliases & starship init
├── config/
│   ├── hypr/
│   │   ├── hyprland.lua          # Main Hyprland config (Lua)
│   │   ├── hypridle.conf         # Idle management (dim → lock → dpms → suspend)
│   │   ├── hyprlock.conf         # Lock screen with blurred wallpaper
│   │   └── hyprlauncher.conf     # App launcher config
│   ├── waybar/
│   │   ├── config.jsonc          # Glassmorphic top bar
│   │   └── style.css             # Neon glow styling
│   ├── kitty/
│   │   └── kitty.conf            # Terminal with Obsidian Glow colors
│   ├── starship/
│   │   └── starship.toml         # Custom Starship prompt theme
│   ├── fastfetch/
│   │   └── config.jsonc          # System info splash screen
│   ├── cava/
│   │   └── config_ags            # Audio visualizer (raw output for widget)
│   ├── music_widget/
│   │   ├── music_widget.py       # GTK Layer Shell music overlay + cava visualizer
│   │   └── toggle_music.sh       # Toggle script (SUPER + N)
│   ├── mpv/                      # Optimized MPV media player config
│   └── Thunar/                   # Minimal Thunar file manager config
├── wallpapers/
│   └── obsidian_glow.jpg         # Default wallpaper
├── install.sh                    # Automated installer
└── README.md
```

---

## 🚀 Quick Install

### Prerequisites

- **Arch Linux** (or Arch-based distro)
- **Hyprland** (0.46+) with Lua config support
- An **AUR helper** (`yay` or `paru`)

### One-liner

```bash
git clone https://github.com/YOUR_USERNAME/obsidian-glow.git ~/obsidian-glow
cd ~/obsidian-glow
chmod +x install.sh
./install.sh
```

The installer will:
1. Install all dependencies via `pacman` and your AUR helper
2. Back up any existing configs (appends `.bak`)
3. Symlink all configs to `~/.config/`
4. Deploy the wallpaper to `~/Pictures/wallpapers/`
5. Set the cursor theme and GTK dark mode

> **Tip:** Use `./install.sh --copy` to copy files instead of symlinking.

After installing, **log out and back into Hyprland** to apply everything.

---

## ⌨️ Keybindings

### Core

| Keybind | Action |
|---------|--------|
| `SUPER + Q` | Open terminal (Kitty) |
| `SUPER + C` | Close window |
| `SUPER + R` | App launcher (Hyprlauncher) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + SHIFT + E` | Yazi (terminal file manager) |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Fullscreen |
| `SUPER + L` | Lock screen |
| `SUPER + M` | Exit Hyprland |

### Music & Media

| Keybind | Action |
|---------|--------|
| `SUPER + N` | Toggle music widget |
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Toggle mute |

### Navigation

| Keybind | Action |
|---------|--------|
| `SUPER + ←↑↓→` | Move focus |
| `SUPER + H/K` | Vim-style focus (left/up) |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + SHIFT + 1-0` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + SHIFT + arrows` | Swap windows |
| `SUPER + ALT + R` | Enter resize mode |
| `SUPER + mouse drag` | Move window |
| `SUPER + mouse right` | Resize window |

### Utilities

| Keybind | Action |
|---------|--------|
| `SUPER + SHIFT + S` | Region screenshot → clipboard |
| `Print` | Full screenshot → file |
| `SUPER + SHIFT + C` | Color picker |
| `SUPER + SHIFT + V` | Clipboard history |

### Gestures (Touchpad)

| Gesture | Action |
|---------|--------|
| 3-finger horizontal swipe | Switch workspace |
| 4-finger swipe up | App launcher |

---

## ⚡ Shell Setup

The shell experience is powered by:

| Tool | Purpose |
|------|---------|
| **Starship** | Fast, customizable prompt with git info, language detection, and Obsidian Glow theme |
| **eza** | Modern `ls` with icons, colors, and git status |
| **bat** | `cat` with syntax highlighting |
| **fastfetch** | System info splash on terminal launch |

### Shell Aliases

| Alias | Command |
|-------|---------|
| `ls` | `eza --icons` |
| `ll` | `eza -lh --icons --git` |
| `la` | `eza -lah --icons --git` |
| `lt` | `eza --tree --level=2` |
| `cat` | `bat` |
| `gs` | `git status -sb` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline --graph` |
| `ff` | `fastfetch` |
| `y` | `yazi` |

---

## 🐉 Native Pentesting (Kali via Distrobox)

This setup integrates **Kali Linux natively into Arch** using Podman and Distrobox, providing a seamless pentesting environment without bloating your host OS.

- **Intelligent Package Manager:** Run `apt update` or `apt install <tool>` directly in your Arch terminal, and it seamlessly routes to the Kali container.
- **Shared Filesystem:** Your `~/.config`, `~/Downloads`, and tools share the same space, meaning any config files generated by Kali tools (like `~/.msf4`) persist safely on your host.
- **Quick Exec:** Use `dbx kali <command>` to run any pentesting tool inside Kali instantly.
- **App Exporting:** Use `dbx-exp kali bin <tool>` to export CLI tools or GUI apps seamlessly to your Arch host.

To initialize this environment after running `install.sh`, create a Kali distrobox:
```bash
distrobox create -n kali --image docker.io/kalilinux/kali-rolling:latest --pre-init-hooks "dpkg-divert --add --rename --divert /usr/bin/systemd-tmpfiles.real /usr/bin/systemd-tmpfiles || true; ln -sf /bin/true /usr/bin/systemd-tmpfiles"
```

---

## 🎵 Music Widget

A custom **GTK Layer Shell** overlay that sits at the bottom of the screen, featuring:

- **Album art** pulled from MPRIS metadata
- **Live cava visualizer** with smooth bar interpolation
- **Playback controls** (prev, play/pause, next)
- **Glassmorphic** dark UI with violet gradient bars

Toggle with `SUPER + N`. Works with any MPRIS-compatible player (Feishin, Firefox, Spotify, etc.)

---

## 🔧 Dependencies

### Official (pacman)

| Package | Purpose |
|---------|---------|
| `hyprland` | Wayland compositor |
| `hyprlock` | Lock screen |
| `hypridle` | Idle daemon |
| `hyprpolkitagent` | Authentication agent |
| `waybar` | Status bar |
| `kitty` | Terminal emulator |
| `thunar` | File manager |
| `dunst` | Notification daemon |
| `playerctl` | MPRIS media controller |
| `cava` | Audio visualizer engine |
| `python-gobject` | GTK Python bindings |
| `gtk-layer-shell` | Wayland overlay support |
| `grim` + `slurp` | Screenshots |
| `wl-clipboard` + `cliphist` | Clipboard management |
| `brightnessctl` | Backlight control |
| `pipewire` + `wireplumber` | Audio stack |
| `pavucontrol` | Volume mixer GUI |
| `ttf-jetbrains-mono-nerd` | Primary UI font |
| `inter-font` | Secondary UI font |
| `starship` | Shell prompt |
| `eza` | Modern ls replacement |
| `bat` | Syntax-highlighted cat |
| `fastfetch` | System info |
| `podman` | Container engine |
| `distrobox` | Native container integration |
| `mpv` | Media player |

### AUR

| Package | Purpose |
|---------|---------|
| `hyprlauncher` | App launcher |
| `awww` | Wallpaper daemon (swww successor) |
| `bibata-cursor-theme` | Cursor theme |
| `feishin-bin` | Navidrome music client (optional) |

---

## 🧩 Manual Install (Step-by-Step)

If you prefer not to use the install script:

### 1. Install dependencies

```bash
# Official repos
sudo pacman -S hyprland hyprlock hypridle hyprpolkitagent waybar kitty thunar \
  dunst playerctl cava python-gobject gtk-layer-shell grim slurp wl-clipboard \
  cliphist brightnessctl pipewire wireplumber pavucontrol \
  ttf-jetbrains-mono-nerd inter-font starship eza bat fastfetch

# AUR (via yay)
yay -S hyprlauncher awww bibata-cursor-theme feishin-bin
```

### 2. Copy configs

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/obsidian-glow.git
cd obsidian-glow

# Hyprland
cp config/hypr/* ~/.config/hypr/

# Waybar
cp config/waybar/* ~/.config/waybar/

# Kitty
cp config/kitty/* ~/.config/kitty/

# Starship
cp config/starship/starship.toml ~/.config/starship.toml

# Fastfetch
mkdir -p ~/.config/fastfetch
cp config/fastfetch/config.jsonc ~/.config/fastfetch/

# Cava
mkdir -p ~/.config/cava
cp config/cava/config_ags ~/.config/cava/

# Music widget
mkdir -p ~/.config/music_widget
cp config/music_widget/* ~/.config/music_widget/
chmod +x ~/.config/music_widget/toggle_music.sh

# Bashrc
cp .bashrc ~/

# Wallpaper
mkdir -p ~/Pictures/wallpapers
cp wallpapers/obsidian_glow.jpg ~/Pictures/wallpapers/
```

### 3. Set cursor & GTK theme

```bash
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
```

### 4. Log out and back into Hyprland

---

## 📄 License

MIT — do whatever you want with it.
