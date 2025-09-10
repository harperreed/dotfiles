# ABOUTME: Direnv integration for per-project environment management
# ABOUTME: Automatically loads .envrc files to set project-specific environment variables

if type -q direnv
  direnv hook fish | source
end