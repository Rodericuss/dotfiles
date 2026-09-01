#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export XDG_CURRENT_DESKTOP=Hyprland

export PATH=$PATH:$HOME/.maestro/bin

eval "$(direnv hook bash)"
eval "$(zoxide init bash)"
