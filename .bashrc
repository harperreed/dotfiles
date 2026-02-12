# ABOUTME: Main bash configuration for interactive shells
# ABOUTME: Sourced by .bash_profile for login shells, directly for non-login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# History
# =============================================================================
HISTCONTROL=erasedups:ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%D %T "
HISTIGNORE="&:ls:exit:cd:pwd:clear"
shopt -s histappend

# =============================================================================
# Shell Options
# =============================================================================
shopt -s checkwinsize
# shopt -s globstar  # Uncomment if you want ** pattern matching

# =============================================================================
# Prompt
# =============================================================================
# Set variable identifying the chroot you work in
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
xterm*|rxvt*|screen*|cygwin*)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[1;36m\]§ \[\033[1;32m\]\h\[\033[0;36m\] {\[\033[1;36m\]\w\[\033[0;36m\]}\[\033[39m\] '
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# =============================================================================
# Colors
# =============================================================================
export CLICOLOR=1
export LSCOLORS=Bxgxfxfxcxdxdxhbadbxbx

# Linux dircolors support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# =============================================================================
# Aliases
# =============================================================================
alias cls=clear
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color'
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

# Alert alias for long running commands (Linux)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# =============================================================================
# Environment
# =============================================================================
export EDITOR=gvim
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# =============================================================================
# PATH Setup
# =============================================================================
# Homebrew (Intel Mac)
[ -d /usr/local/bin ] && export PATH="/usr/local/bin:$PATH"

# Homebrew (Apple Silicon)
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Go - check common GOPATH locations
if [ -d "$HOME/workspace/personal/go" ]; then
    export GOPATH="$HOME/workspace/personal/go"
elif [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
fi
[ -n "$GOPATH" ] && export PATH="$PATH:$GOPATH/bin"
[ -d /usr/local/go/bin ] && export PATH="$PATH:/usr/local/go/bin"

# npm global
if [ -d ~/.npm-global ]; then
    export NPM_CONFIG_PREFIX=~/.npm-global
    export PATH="$PATH:$HOME/.npm-global/bin"
fi
[ -d /usr/local/share/npm/bin ] && export PATH="$PATH:/usr/local/share/npm/bin"

# LM Studio CLI
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

# =============================================================================
# External Tool Integrations
# =============================================================================
# Bash aliases file
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Nix
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Lazy-load conda (only initializes when you first use it)
conda() {
    unset -f conda
    if [ -f "$HOME/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.miniconda3/bin:$PATH"
    fi
    conda "$@"
}

# lesspipe for friendly non-text file viewing
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Local environment
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Atuin shell history
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin &>/dev/null && eval "$(atuin init bash)"
