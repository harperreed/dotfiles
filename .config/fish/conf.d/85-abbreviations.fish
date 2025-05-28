# ABOUTME: Fish abbreviations for common commands
# ABOUTME: Abbreviations expand inline and are more efficient than aliases

# Navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'

# Common shortcuts
abbr -a g git
abbr -a v nvim
abbr -a vim nvim
abbr -a dc docker-compose
abbr -a k kubectl

# Git shortcuts (more efficient than aliases)
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git pull'

# System
abbr -a update 'brew update && brew upgrade'
abbr -a cleanup 'brew cleanup'

# Network
abbr -a myip 'curl ipinfo.io/ip'
abbr -a localip 'ipconfig getifaddr en0'

# Misc
abbr -a weather 'curl wttr.in'