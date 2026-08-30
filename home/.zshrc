# Lines configured by zsh-newuser-install
HISTFILE='~/.histfile'
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/amitis/.zshrc'
export XDG_CURRENT_DESKTOP=Hyprland
# Scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export COLORTERM=truecolor
export TERM=xterm-kitty
#bashrc stuff
alias pag='ps aux | grep'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

autoload -Uz compinit
compinit
# End of lines added by compinstall

export PATH="/usr/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"

eval "$(starship init zsh)"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:$HOME/.maestro/bin

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

export MANPAGER="nvim +Man!"
export BROWSER=qutebrowser
export EDITOR=nvim
export VISUAL=nvim
command -v npm >/dev/null 2>&1 && export PATH="$PATH:$(npm prefix -g)/bin"

# ~/scripts/durdurdur.sh
export EDITOR=nvim
export VISUAL=nvim
