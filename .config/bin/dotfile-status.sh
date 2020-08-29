#!/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

if [ -d $HOME/Dropbox/Utilities/dotfiles ];
then
  export DOTFILES=$HOME/Dropbox/Utilities/dotfiles/
fi


if [ -d $HOME/.dotfiles ];
then
  export DOTFILES=$HOME/.dotfiles/
fi

CHECK=false

LOCKFILE=~/.dotfiles-status

if [ ! -f $LOCKFILE ];
then
  touch $LOCKFILE
  CHECK=true
fi


if test `find "$LOCKFILE" -mmin +1440`
then
  CHECK=true

fi

if $CHECK
then
    cd $DOTFILES
    [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ] && echo "" >$LOCKFILE || echo "\n\n${RED}WARNING${NC} Your dotfiles are not up to date">$LOCKFILE
fi

cat $LOCKFILE
