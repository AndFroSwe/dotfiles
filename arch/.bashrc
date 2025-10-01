#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

## Andfro
# Aliases
alias ll='ls -al'

# Update the path
export PATH=$PATH:~/.local/bin

# Add color to kitty
case "$TERM" in xterm-color | *-256color | xterm-kitty) color_prompt=yes ;; esac

# Get Better PS1
eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/andfro.omp.json)"
