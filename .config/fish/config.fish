# ABOUTME: Main fish shell configuration file
# ABOUTME: Loads aliases and remaining configuration after conf.d/ files

# Source aliases
if test -f ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end

# Any remaining custom configuration can go here
# Most configuration is now handled by conf.d/ files in order:
# 00-env.fish         - Environment variables
# 10-paths.fish       - PATH configuration
# 20-secrets.fish     - Secret loading
# 30-ssh-agent.fish   - SSH agent setup
# 40-platform-*.fish  - Platform-specific config
# 50-greeting.fish    - Custom greeting
# 60-prompt.fish      - Prompt configuration
# 85-abbreviations.fish - Command abbreviations
# 90-plugins.fish     - Plugin initialization

# pnpm
set -gx PNPM_HOME "/Users/harper/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# OpenClaw Completion
if test -f ~/.openclaw/completions/openclaw.fish
    source ~/.openclaw/completions/openclaw.fish
end
