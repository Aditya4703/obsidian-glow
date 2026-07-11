#
# ~/.bashrc — Obsidian Glow
#

# ── Ble.sh — MUST be first (syntax highlighting + autosuggestions) ──
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach

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
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first --git'
alias la='eza -lah --icons --group-directories-first --git'
alias lt='eza --tree --icons --level=2 --group-directories-first'
alias l.='eza -d .* --icons'
alias cat='bat --style=auto'
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

# ── Colored Man Pages ───────────────────────────────────
export MANPAGER="less -R --use-color -Dd+m -Du+c"
export MANROFFOPT="-c"

# ── Path ─────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ───────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── Fastfetch Greeting ───────────────────────────────────
fastfetch

# ── Starship Prompt (must be before ble-attach) ──────────
eval "$(starship init bash)"

# ── Ble.sh Theme — Obsidian Glow (applied after attach) ──
if [[ ${BLE_VERSION-} ]]; then
    function _obsidian_glow_theme {
        # Syntax highlighting
        ble-face -s syntax_default           fg=253
        ble-face -s syntax_command           fg=141,bold
        ble-face -s syntax_quoted            fg=73
        ble-face -s syntax_quotation         fg=73,bold
        ble-face -s syntax_escape            fg=204
        ble-face -s syntax_expr              fg=141
        ble-face -s syntax_error             fg=204,bg=52
        ble-face -s syntax_varname           fg=80
        ble-face -s syntax_delimiter         fg=247
        ble-face -s syntax_param_expansion   fg=141
        ble-face -s syntax_history_expansion fg=80
        ble-face -s syntax_function_name     fg=141,bold
        ble-face -s syntax_comment           fg=242,italic
        ble-face -s syntax_glob              fg=214
        ble-face -s syntax_brace             fg=214
        ble-face -s syntax_tilde             fg=80
        ble-face -s syntax_document          fg=73
        ble-face -s syntax_document_begin    fg=73,bold
        ble-face -s command_builtin          fg=80
        ble-face -s command_builtin_dot      fg=80,bold
        ble-face -s command_alias            fg=141
        ble-face -s command_function         fg=141
        ble-face -s command_file             fg=78
        ble-face -s command_keyword          fg=204
        ble-face -s command_jobs             fg=214
        ble-face -s command_directory        fg=80,bold
        ble-face -s filename_directory       fg=80,bold
        ble-face -s filename_executable      fg=78
        ble-face -s filename_link            fg=80
        ble-face -s filename_orphan          fg=204
        ble-face -s filename_other           fg=253
        ble-face -s varname_array            fg=214
        ble-face -s varname_export           fg=141,bold
        ble-face -s varname_number           fg=78
        ble-face -s varname_readonly         fg=204
        ble-face -s varname_unset            fg=242
        ble-face -s auto_complete            fg=240
        ble-face -s region                   fg=253,bg=236
        ble-face -s region_insert            fg=253,bg=236
        ble-face -s disabled                 fg=242
        ble-face -s overwrite_mode           fg=253,bg=55
        ble-face -s menu_filter_fixed        bold
        ble-face -s menu_filter_input        fg=141

        bleopt complete_auto_delay=100
        bleopt complete_auto_complete=1
    }
    blehook ATTACH+=_obsidian_glow_theme
fi

# ── Ble.sh attach — MUST be last ────────────────────────
[[ ${BLE_VERSION-} ]] && ble-attach
