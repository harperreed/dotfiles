# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Comment in the above and uncomment this below for a color prompt
case "$TERM" in
xterm*|rxvt*|screen*|cygwin*)
#   PS1='${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h\[\033[00m\] {\[\033[36m\]\w\[\033[00m\]} '
   PS1='${debian_chroot:+($debian_chroot)}\[\033[1;36m\]§ \[\033[1;32m\]\h\[\033[0;36m\] {\[\033[1;36m\]\w\[\033[0;36m\]}\[\033[39m\] '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export CLICOLOR=1
# use yellow for directories
export LSCOLORS=dxfxcxdxbxegedabagacad
export LSCOLORS=Bxgxfxfxcxdxdxhbadbxbx


alias cls=clear
export TOOLS="$HOME/Dropbox/Utilities/dotfiles/"
export GEMS="$HOME/.gem/ruby/1.8/bin"
export HOMEBREW="/usr/local/bin"
export PATH=$HOMEBREW:$TOOLS/bin:$GEMS:$PATH
export RUBYOPT=rubygems

alias grep='grep --color'
export EDITOR=gvim

#history
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTTIMEFORMAT="%D %T "
export HISTIGNORE="&:ls:exit"
shopt -s histappend

# alias sub='/Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2'
#
if [ -d $HOME/src/go ]; then
    export GOPATH=$HOME/src/go
fi
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin/
export PATH=$PATH:/usr/local/share/npm/bin/  
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CG\Session -suspend'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


if [ -f /usr/local/google-cloud-sdk/path.bash.inc ]; then
    source '/usr/local/google-cloud-sdk/path.bash.inc'
fi

if [ -f /usr/local/google-cloud-sdk/completion.bash.inc ]; then
    source '/usr/local/google-cloud-sdk/completion.bash.inc'
fi

#$ using npm dir?
if [ -d  ~/.npm-global ]; then
  export NPM_CONFIG_PREFIX=~/.npm-global
  export PATH=~/.npm-global/bin:$PATH
fi


#
# run fortune at startup
#
hostname |figlet -f ~/.config/fonts/Bloody.flf|lolcat
fortune |lolcat


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
-e 
if [ -e /home/harper/.nix-profile/etc/profile.d/nix.sh ]; then . /home/harper/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/harper/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/harper/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/harper/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/harper/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/harper/.lmstudio/bin"
# End of LM Studio CLI section


. "$HOME/.local/share/../bin/env"

. "$HOME/.atuin/bin/env"

export PATH="/Users/harper/.local/share/solana/install/active_release/bin:$PATH"
