#
# ~/.bashrc — Obsidian Glow
#

# ── Ble.sh — MUST be first (syntax highlighting + autosuggestions) ──
if [[ -f /usr/share/blesh/ble.sh ]]; then
    [[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ── History ──────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:pwd:clear:exit"
shopt -s histappend

# ── Shell Options ────────────────────────────────────────
shopt -s checkwinsize   # Update LINES/COLUMNS after each command
shopt -s cdspell        # Autocorrect minor cd typos
shopt -s dirspell       # Autocorrect dir typos in completion
shopt -s expand_aliases
shopt -s globstar       # ** matches recursively

# ── Bash Completion ──────────────────────────────────────
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# ── Aliases — Files & Navigation ─────────────────────────
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first --git'
    alias la='eza -lah --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2 --group-directories-first'
    alias l.='eza -d .* --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'

# ── Aliases — System ─────────────────────────────────────
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ip='ip -color=auto'
alias diff='diff --color=auto'

# ── Aliases — Git ────────────────────────────────────────
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -15'
alias gd='git diff'

# ── Aliases — Shortcuts ──────────────────────────────────
alias hc='hyprctl'
alias ff='fastfetch'
alias cls='clear'
alias v='nvim'
alias y='yazi'
alias open='xdg-open'

# ── Distrobox Smart Wrappers ─────────────────────────────
# Automatically route package managers to their respective containers
function _dbx_run_pm() {
    local pm="$1"
    shift
    local target=""
    
    if [[ "$pm" == "apt" ]]; then
        target=$(distrobox list --no-color | awk -F '|' 'NR>1 && $0 ~ /kali|ubuntu|debian/ {print $2; exit}' | tr -d ' ')
    elif [[ "$pm" == "dnf" ]]; then
        target=$(distrobox list --no-color | awk -F '|' 'NR>1 && $0 ~ /fedora|rhel|centos|almalinux|rockylinux/ {print $2; exit}' | tr -d ' ')
    fi
    
    if [[ -z "$target" ]]; then
        echo -e "\e[1;31mError:\e[0m No suitable container found for '$pm' (check distrobox list)."
        return 1
    fi
    
    echo -e "\e[1;36m[$target]\e[0m Running $pm..."
    distrobox-enter "$target" -- sudo "$pm" "$@"
    
    if [[ "$1" == "install" ]]; then
        echo -e "\n\e[1;35m[Tip]\e[0m To export installed tools to Arch, use:"
        echo -e "  dbx-exp $target bin <command>"
        echo -e "  dbx-exp $target app <gui_app>"
    fi
}

function apt() { _dbx_run_pm apt "$@"; }
function dnf() { _dbx_run_pm dnf "$@"; }

# Execute a quick command in a container (Usage: dbx kali nmap) or enter it (Usage: dbx kali)
function dbx() {
    local container="$1"
    shift
    if [[ -z "$container" ]]; then
        echo "Usage: dbx <container_name> [command...]"
        return 1
    fi
    if [[ -n "$1" ]]; then
        distrobox-enter "$container" -- "$@"
    else
        distrobox-enter "$container"
    fi
}

# Export tools from a container manually (Usage: dbx-exp kali bin nmap)
function dbx-exp() {
    local container="$1"
    local type="$2"
    local name="$3"
    
    if [[ -z "$name" || ("$type" != "bin" && "$type" != "app") ]]; then
        echo "Usage: dbx-exp <container> [bin|app] <name>"
        return 1
    fi
    
    if [[ "$type" == "bin" ]]; then
        # Handle cases where bin might be in /bin or /usr/sbin but /usr/bin is standard
        distrobox-enter "$container" -- distrobox-export --bin "/usr/bin/$name"
    else
        distrobox-enter "$container" -- distrobox-export --app "$name"
    fi
}

# ── Colored Man Pages ───────────────────────────────────
export MANPAGER="less -R --use-color -Dd+m -Du+c"
export MANROFFOPT="-c"

# ── Path ─────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ───────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── Fastfetch Greeting ───────────────────────────────────
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# ── Starship Prompt (must be before ble-attach) ──────────
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# ── Ble.sh attach — MUST be last ────────────────────────
[[ ${BLE_VERSION-} ]] && ble-attach

export PATH="/home/aditya/Android/Sdk/build-tools/36.1.0:/home/aditya/Android/Sdk/platform-tools:$PATH"
