# ABOUTME: Fish aliases for commands that need complex arguments
# ABOUTME: Simple shortcuts are in conf.d/85-abbreviations.fish (preferred)

# Modern CLI replacements (these override builtins, so must be aliases not abbreviations)
if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza --icons --group-directories-first -la'
    alias la 'eza --icons --group-directories-first -a'
    alias l 'eza --icons --group-directories-first'
    alias tree 'eza --tree --icons'
end

if type -q rg
    alias grep rg
end

if type -q btm
    alias top btm
end

if type -q pygmentize
    alias ccat 'pygmentize -g'
end

# macOS Finder helpers (complex commands that shouldn't expand inline)
if test (uname) = "Darwin"
    alias showfiles 'defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
end

# Lazygit
if type -q lazygit
    alias lg lazygit
end
