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
