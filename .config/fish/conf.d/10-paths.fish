# ABOUTME: Manages PATH configuration for fish shell
# ABOUTME: Uses fish_add_path to prevent duplicates and maintain order

# Homebrew (must come early so brew-installed tools are available)
if test -d /opt/homebrew/bin
    fish_add_path -g /opt/homebrew/bin
    fish_add_path -g /opt/homebrew/sbin
end

# Base paths (fish_add_path automatically prevents duplicates)
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.config/bin
fish_add_path -g $HOME/.npm-global/bin
fish_add_path -g /usr/local/sbin

# Language-specific paths
fish_add_path -g $HOME/.cargo/bin  # Rust

# Platform-specific paths will be added in platform-specific files
# (e.g., Go paths, Homebrew paths)