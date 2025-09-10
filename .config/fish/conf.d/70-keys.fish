# ABOUTME: Default key bindings, bang-bang (!!), and quick shell reload
# ABOUTME: Essential keyboard shortcuts and shell management functions

# Default mode (not Vi)
fish_default_key_bindings

# "!!" -> last command (works anywhere)
function __hist_last_cmd; echo $history[1]; end
abbr -a !! --position anywhere --function __hist_last_cmd

# Quick shell reload
function reload --description 'restart fish login shell'
  exec fish -l
end