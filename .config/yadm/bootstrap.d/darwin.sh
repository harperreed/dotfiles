#!/bin/bash
# ABOUTME: Darwin (macOS) specific bootstrap script
# ABOUTME: Installs Homebrew, packages, and configures macOS system

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

log_info "Starting Darwin bootstrap"

# Configuration
readonly HOMEBREW_PREFIX_INTEL="/usr/local"
readonly HOMEBREW_PREFIX_ARM="/opt/homebrew"
readonly BREWFILE_PATH="$HOME/.config/brewfile/Brewfile"

# Detect architecture and set Homebrew path
get_homebrew_prefix() {
    local arch=$(uname -m)
    case "$arch" in
        arm64) echo "$HOMEBREW_PREFIX_ARM" ;;
        x86_64) echo "$HOMEBREW_PREFIX_INTEL" ;;
        *) die "Unsupported architecture: $arch" ;;
    esac
}

# Install Homebrew
install_homebrew() {
    if command_exists brew; then
        log_info "Homebrew is already installed"
        return 0
    fi
    
    log_info "Installing Homebrew"
    
    # Check for Command Line Tools
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools"
        run_command "xcode-select --install"
        
        # Wait for installation
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
    fi
    
    # Install Homebrew
    if [[ "$DRY_RUN" != "true" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || die "Failed to install Homebrew"
    else
        log_info "[DRY RUN] Would install Homebrew"
    fi
    
    # Add Homebrew to PATH for this session
    local brew_prefix=$(get_homebrew_prefix)
    if [[ -f "$brew_prefix/bin/brew" ]]; then
        eval "$($brew_prefix/bin/brew shellenv)"
    fi
}

# Configure Homebrew in shell profile
configure_homebrew_path() {
    local brew_prefix=$(get_homebrew_prefix)
    local brew_env="eval \"\$($brew_prefix/bin/brew shellenv)\""
    
    # Add to various shell configs
    for rc_file in "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.profile"; do
        if [[ -f "$rc_file" ]] || [[ "$rc_file" == "$HOME/.zprofile" ]]; then
            add_to_shell_rc "$brew_env" "$rc_file"
        fi
    done
}

# Install packages from Brewfile
install_brewfile() {
    if ! file_exists "$BREWFILE_PATH"; then
        log_warn "Brewfile not found at $BREWFILE_PATH"
        return 0
    fi
    
    log_info "Installing packages from Brewfile"
    
    # Update Homebrew first
    run_command "brew update"
    
    # Install from Brewfile
    run_command "brew bundle --file '$BREWFILE_PATH' --no-lock"
    
    # Cleanup
    if confirm "Run brew cleanup?"; then
        run_command "brew cleanup"
    fi
}

# Configure Fish shell
configure_fish_shell() {
    if ! command_exists fish; then
        log_warn "Fish shell not installed, skipping configuration"
        return 0
    fi
    
    local fish_path=$(command -v fish)
    
    # Check if fish is already in /etc/shells
    if grep -q "^$fish_path$" /etc/shells; then
        log_info "Fish shell already in /etc/shells"
    else
        log_info "Adding Fish shell to /etc/shells"
        require_sudo
        run_command "echo '$fish_path' | sudo tee -a /etc/shells"
    fi
    
    # Check current shell
    local current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
    if [[ "$current_shell" == "$fish_path" ]]; then
        log_info "Fish is already the default shell"
    else
        if confirm "Set Fish as default shell?"; then
            run_command "chsh -s '$fish_path'"
            log_success "Fish set as default shell"
        fi
    fi
}

# Install fonts
install_fonts() {
    local font_dir="$HOME/.config/fonts"
    local system_font_dir="/Library/Fonts"
    
    if ! dir_exists "$font_dir"; then
        log_info "Font directory not found: $font_dir"
        return 0
    fi
    
    log_info "Installing fonts"
    
    local font_count=0
    local installed_count=0
    
    # Count total fonts
    while IFS= read -r -d '' font; do
        ((font_count++))
    done < <(find "$font_dir" -name "*.ttf" -o -name "*.otf" -print0)
    
    if [[ $font_count -eq 0 ]]; then
        log_info "No fonts found to install"
        return 0
    fi
    
    # Install fonts
    while IFS= read -r -d '' font; do
        local font_name=$(basename "$font")
        local target="$system_font_dir/$font_name"
        
        ((installed_count++))
        show_progress $installed_count $font_count "Installing fonts"
        
        if [[ -f "$target" ]]; then
            log_info "Font already installed: $font_name"
        else
            require_sudo
            run_command "sudo cp '$font' '$target'"
        fi
    done < <(find "$font_dir" -name "*.ttf" -o -name "*.otf" -print0)
    
    log_success "Installed $installed_count fonts"
}

# macOS-specific settings
configure_macos_settings() {
    log_info "Configuring macOS settings"
    
    # Only run if not in dry-run mode
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would configure macOS settings"
        return 0
    fi
    
    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    
    # Enable key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    
    # Set fast key repeat
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Restart affected applications
    killall Finder || true
    
    log_success "macOS settings configured"
}

# Main Darwin bootstrap
main() {
    log_info "Darwin bootstrap started"
    
    # Check if running on macOS
    if [[ "$(uname -s)" != "Darwin" ]]; then
        die "This script is for macOS only"
    fi
    
    # Run bootstrap tasks
    install_homebrew
    configure_homebrew_path
    install_brewfile
    configure_fish_shell
    install_fonts
    
    if confirm "Configure macOS settings?"; then
        configure_macos_settings
    fi
    
    log_success "Darwin bootstrap completed"
    
    # Remind about manual steps
    log_info "Remember to:"
    log_info "  - Restart terminal for shell changes"
    log_info "  - Sign in to App Store for Mac App Store apps"
    log_info "  - Run 'brew doctor' to verify installation"
}

# Run main function
main "$@"