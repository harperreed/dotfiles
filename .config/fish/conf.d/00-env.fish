# ABOUTME: Environment variable configuration for fish shell
# ABOUTME: Sets up all global environment variables in one central location

# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_STATE_HOME $HOME/.local/state

# Default editors
set -gx EDITOR nvim
set -gx VISUAL nvim

# Language and locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Python settings
set -gx PYTHONDONTWRITEBYTECODE 1

# Node.js settings
set -gx NODE_ENV development
set -x OSTYPE (uname | tr '[:upper:]' '[:lower:]')

# Disable virtualenv prompt (we handle it in our custom prompt)
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Platform-specific environment variables will be set in platform-specific files