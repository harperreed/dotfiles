# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

# Shortcuts
alias g git
alias v nvim
alias vim nvim
alias dc 'docker-compose'
alias k kubectl

# List files
alias ll 'ls -lah'
alias la 'ls -A'
alias l 'ls -CF'

# System
alias update 'brew update && brew upgrade'
alias cleanup 'brew cleanup'

# Network
alias myip 'curl ipinfo.io/ip'
alias localip "ipconfig getifaddr en0"

# Misc
alias weather 'curl wttr.in'
alias ccat 'pygmentize -g'

# macOS specific
alias showfiles 'defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Git
alias gs 'git status'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias gl 'git pull'
