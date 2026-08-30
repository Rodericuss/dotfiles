# ---------------------------------------
# CYBRfish    fish shell theme & config (part of cybrland)
# Project:    https://github.com/scherrer-txt/cybrland
# Author:     scherrer-txt   |   License:     GPL-3.0
# Source:     ~/.config/fish/config.fish
# ---------------------------------------

# Environment
set -gx STARSHIP_CONFIG ~/.config/starship.toml

set -gx TERM xterm-kitty
set -gx COLORTERM truecolor
set -gx MICRO_TRUECOLOR 1

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Local bins
fish_add_path ~/.local/bin

# Emulator fix
set -gx QT_QPA_PLATFORM xcb

# Zoxide
zoxide init fish --cmd cd | source

# Eza aliases
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree'

function upall
    sudo pacman -Syu
end

## Key bindings
set -U fish_key_bindings fish_default_key_bindings

starship init fish | source
enable_transience
function starship_transient_prompt_func
  starship module character
end
function starship_transient_rprompt_func
    starship module custom.time_arrow
    starship module custom.transient_time
end
zoxide init fish | source
set -gx SEARXNG_API_URL "http://localhost:9090"
alias avante='nvim -c "lua vim.defer_fn(function() require(\"avante.api\").zen_mode() end, 100)"'

# Optional local completion
test -f "$HOME/.openclaw/completions/openclaw.fish"; and source "$HOME/.openclaw/completions/openclaw.fish"
