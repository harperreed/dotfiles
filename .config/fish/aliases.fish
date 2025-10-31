# List files (keep as aliases since they have arguments)
alias ll 'ls -lah'
alias la 'ls -A'
alias l 'ls -CF'

# Potentially dangerous - requires pygmentize
alias ccat 'pygmentize -g'

# macOS specific (keep as aliases due to complexity)
alias showfiles 'defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Note: Most aliases have been converted to abbreviations in conf.d/85-abbreviations.fish
# Abbreviations are more efficient and expand inline for better history

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
alias lg lazygit

# Modern CLI replacements
alias cat bat
alias ls 'eza --icons --group-directories-first'
alias ll 'eza --icons --group-directories-first -la'
alias la 'eza --icons --group-directories-first -a'
alias l 'eza --icons --group-directories-first'
alias tree 'eza --tree --icons'
alias du dust
# alias find fd
alias grep rg
alias top btm
