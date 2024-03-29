# Bindkey
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space

# Less settings
#
# -F    exit if the file can be displayed in one screen
# -g    highlight only the particular string found by the last search command
# -i    ignore case in search commands unless an uppercase letter is present
# -M    prompt more verbosely
# -R    display ANSI "color" escape sequences in their raw form
# -S    chop long lines (instead of wrapping)
# -W    highlight the first "new" line after forward movement
# -X    disables clearing the screen after exiting
# -x4   display tabs as 4-character width
# -z-4  always keep 4 lines overlapping with the previous screen
export LESS='-F -g -i -M -R -S -W -X -x4 -z-4'

# Set colors for less (see https://wiki.archlinux.org/index.php/Color_output_in_console#less)
export LESS_TERMCAP_mb=$'\E[31m'    # begin bold
export LESS_TERMCAP_md=$'\E[34m'    # begin blink
export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
export LESS_TERMCAP_so=$'\E[32m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
export LESS_TERMCAP_us=$'\E[33m'    # begin underline
export LESS_TERMCAP_ue=$'\E[0m'     # reset underline

# Source local zshrc if present
test -s "$HOME/.zshrc.local" && source "$HOME/.zshrc.local"

# Preferred tmux pane arrangement
# Taken from: https://youtu.be/sSOfr2MtRU8
ide () {
  tmux split-window -v -p 38 # 100 - 100 / 1.618
  tmux split-window -h -p 50
  tmux select-pane -t 0
}

# Tmux aliases
alias tl='tmux list-sessions'
alias ts='tmux new-session -s'
alias ta='tmux attach -t'
alias tk='tmux kill-session -t'

# Git aliases
# Taken from: https://github.com/holman/dotfiles/blob/master/git/aliases.zsh
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gs='git status -sb'
alias gl='git log'
alias gll='git ll'
alias gd='git diff'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpsup='git push --set-upstream'
alias grups='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'

alias gup='git pull --rebase'
alias grv='git remote -v'

# Initialize Zoxide
# https://github.com/ajeetdsouza/zoxide#installation
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Initialize 'pyenv'
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

# Nix aliases
alias ns='nix-shell'
alias ne='nix-env'

# Command line calculator from https://unix.stackexchange.com/a/480316
calc () {
  local in="$(echo " $*" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
  gawk -v PREC=201 'BEGIN {printf("%.60g\n", '"${in-0}"')}' < /dev/null
}

# Bat ('cat' replacement) aliases
alias bat="bat --theme=TwoDark"
alias cat="bat"
alias f="cat"

# Eza ('ls' replacement) aliases
alias ls="eza --color=auto --group-directories-first" # use color and group directories first
alias ll="ls --long --header --git"                   # long format, with headers and git status
alias la="ll -a"                                      # show all files
alias lm="ll --sort=modified"                         # show by modified date (oldest first)
alias lt="ll --tree"                                  # show filetree
alias l="ll"                                          # pacify the monster

# Colorize some programs if '~/.dircolors' exists
if (( $+commands[dircolors] )); then
    test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Safety first…
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Misc
alias c='clear' # easier than <prefix> C-l in a tmux session
alias mkdir='mkdir -p'
alias du='du -h'
alias glow='glow -p'
alias ..='cd ../.'
alias ...='cd ../../.'
alias ....='cd ../../../.'
alias .....='cd ../../../../.'

