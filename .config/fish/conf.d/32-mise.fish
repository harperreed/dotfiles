# ABOUTME: Mise activation for unified runtime management
# ABOUTME: Replaces nvm, pyenv, etc. with a single fast tool for all languages
status is-interactive; or return

# Activate mise if available
if type -q mise
  mise activate fish | source
end