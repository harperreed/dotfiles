#!/bin/bash
# ABOUTME: Linux-specific bootstrap script with GUI/headless detection
# ABOUTME: Installs packages and configures Linux system

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

log_info "Starting Linux bootstrap"

# Configuration
readonly APT_KEYRINGS_DIR="/usr/share/keyrings"
readonly APT_SOURCES_DIR="/etc/apt/sources.list.d"

# Base packages for all Linux systems
readonly BASE_PACKAGES=(
    fish
    yadm
    figlet
    lolcat
    fortune
    speedtest-cli
    bsdgames
    golang-go
    neovim
    curl
    wget
    git
    htop
    build-essential
)

# GUI-specific packages
readonly GUI_PACKAGES=(
    variety
    kitty
    remmina
    vim-gtk
)

# Detect if system has GUI
has_gui() {
    # Check for X11
    if [[ -n "${DISPLAY:-}" ]] && xset q &>/dev/null; then
        return 0
    fi
    
    # Check for Wayland
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        return 0
    fi
    
    # Check if any desktop environment is installed
    if command_exists gnome-shell || command_exists plasmashell || command_exists xfce4-session; then
        return 0
    fi
    
    return 1
}

# Update package lists
update_apt() {
    log_info "Updating package lists"
    require_sudo
    run_command "sudo apt-get update"
}

# Install packages with proper error handling
install_packages() {
    local packages=("$@")
    local failed_packages=()
    
    for package in "${packages[@]}"; do
        if is_package_installed "$package"; then
            log_info "Package already installed: $package"
        else
            log_info "Installing package: $package"
            if ! run_command "sudo apt-get install -y '$package'"; then
                failed_packages+=("$package")
                log_error "Failed to install: $package"
            fi
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_error "Failed to install packages: ${failed_packages[*]}"
        return 1
    fi
    
    return 0
}

# Add repository with modern key management
add_apt_repository() {
    local name="$1"
    local key_url="$2"
    local repo_line="$3"
    local key_file="${APT_KEYRINGS_DIR}/${name}.gpg"
    local list_file="${APT_SOURCES_DIR}/${name}.list"
    
    # Check if already configured
    if [[ -f "$list_file" ]]; then
        log_info "Repository already configured: $name"
        return 0
    fi
    
    log_info "Adding repository: $name"
    require_sudo
    
    # Ensure keyrings directory exists
    run_command "sudo mkdir -p '$APT_KEYRINGS_DIR'"
    
    # Download and add key
    log_info "Adding GPG key for $name"
    if [[ "$key_url" =~ \.asc$ ]] || [[ "$key_url" =~ \.key$ ]]; then
        # ASCII armored key
        run_command "curl -fsSL '$key_url' | sudo gpg --dearmor -o '$key_file'"
    else
        # Binary key
        run_command "sudo curl -fsSL -o '$key_file' '$key_url'"
    fi
    
    # Add repository
    log_info "Adding repository source for $name"
    run_command "echo '$repo_line' | sudo tee '$list_file' > /dev/null"
    
    log_success "Repository added: $name"
}

# Install third-party repositories
setup_repositories() {
    local arch=$(dpkg --print-architecture)
    
    if has_gui; then
        # Visual Studio Code
        add_apt_repository \
            "vscode" \
            "https://packages.microsoft.com/keys/microsoft.asc" \
            "deb [arch=$arch signed-by=$APT_KEYRINGS_DIR/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main"
        
        # 1Password
        add_apt_repository \
            "1password" \
            "https://downloads.1password.com/linux/keys/1password.asc" \
            "deb [arch=$arch signed-by=$APT_KEYRINGS_DIR/1password.gpg] https://downloads.1password.com/linux/debian/amd64 stable main"
        
        # Syncthing
        add_apt_repository \
            "syncthing" \
            "https://syncthing.net/release-key.gpg" \
            "deb [signed-by=$APT_KEYRINGS_DIR/syncthing.gpg] https://apt.syncthing.net/ syncthing stable"
    fi
    
    # Tailscale
    add_apt_repository \
        "tailscale" \
        "https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg" \
        "deb [signed-by=$APT_KEYRINGS_DIR/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main"
    
    # Node.js (using NodeSource)
    local node_version="20"  # Use LTS version
    add_apt_repository \
        "nodesource" \
        "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" \
        "deb [signed-by=$APT_KEYRINGS_DIR/nodesource.gpg] https://deb.nodesource.com/node_$node_version.x nodistro main"
}

# Configure 1Password (GUI only)
configure_1password() {
    if ! has_gui || ! is_package_installed "1password"; then
        return 0
    fi
    
    log_info "Configuring 1Password"
    
    # Setup debsig for package verification
    local policy_dir="/etc/debsig/policies/AC2D62742012EA22"
    local keyring_dir="/usr/share/debsig/keyrings/AC2D62742012EA22"
    
    require_sudo
    run_command "sudo mkdir -p '$policy_dir' '$keyring_dir'"
    
    # Download policy and keyring
    run_command "curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee '$policy_dir/1password.pol' > /dev/null"
    run_command "curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output '$keyring_dir/debsig.gpg'"
    
    log_success "1Password configured"
}

# Install Discord (GUI only)
install_discord() {
    if ! has_gui; then
        return 0
    fi
    
    if command_exists discord; then
        log_info "Discord already installed"
        return 0
    fi
    
    log_info "Installing Discord"
    
    local discord_deb="/tmp/discord-$$.deb"
    
    # Download Discord
    if run_command "wget -O '$discord_deb' 'https://discord.com/api/download?platform=linux&format=deb'"; then
        # Install package
        require_sudo
        if run_command "sudo dpkg -i '$discord_deb'"; then
            log_success "Discord installed"
        else
            # Fix dependencies if needed
            log_info "Fixing Discord dependencies"
            run_command "sudo apt-get install -f -y"
        fi
        
        # Cleanup
        rm -f "$discord_deb"
    else
        log_error "Failed to download Discord"
        return 1
    fi
}

# Configure Fish shell
configure_fish_shell() {
    if ! command_exists fish; then
        log_warn "Fish shell not installed, skipping configuration"
        return 0
    fi
    
    local fish_path=$(command -v fish)
    
    # Check if fish is in /etc/shells
    if grep -q "^$fish_path$" /etc/shells; then
        log_info "Fish shell already in /etc/shells"
    else
        log_info "Adding Fish shell to /etc/shells"
        require_sudo
        run_command "echo '$fish_path' | sudo tee -a /etc/shells"
    fi
    
    # Check current shell
    local current_shell=$(getent passwd "$USER" | cut -d: -f7)
    if [[ "$current_shell" == "$fish_path" ]]; then
        log_info "Fish is already the default shell"
    else
        log_info "Current shell: $current_shell"
        log_info "To change to Fish, run: chsh -s $fish_path"
    fi
}

# Main Linux bootstrap
main() {
    log_info "Linux bootstrap started"
    
    # Check if running on Linux
    if [[ "$(uname -s)" != "Linux" ]]; then
        die "This script is for Linux only"
    fi
    
    # Check distribution
    if [[ ! -f /etc/debian_version ]]; then
        die "This script currently only supports Debian-based distributions"
    fi
    
    # Initial update
    update_apt
    
    # Install base packages
    log_info "Installing base packages"
    install_packages "${BASE_PACKAGES[@]}"
    
    # GUI-specific setup
    if has_gui; then
        log_info "GUI environment detected"
        
        # Install GUI packages
        log_info "Installing GUI packages"
        install_packages "${GUI_PACKAGES[@]}"
        
        # Setup repositories
        setup_repositories
        update_apt
        
        # Install repository packages
        local repo_packages=(code syncthing 1password)
        install_packages "${repo_packages[@]}"
        
        # Configure 1Password
        configure_1password
        
        # Install Discord
        install_discord
    else
        log_info "Headless environment detected, skipping GUI packages"
        
        # Still install some repositories for headless
        add_apt_repository \
            "tailscale" \
            "https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg" \
            "deb [signed-by=$APT_KEYRINGS_DIR/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main"
        
        update_apt
        install_packages tailscale nodejs
    fi
    
    # Configure Fish shell
    configure_fish_shell
    
    # Cleanup
    if confirm "Clean up package cache?"; then
        run_command "sudo apt-get autoremove -y"
        run_command "sudo apt-get autoclean"
    fi
    
    log_success "Linux bootstrap completed"
    
    # Final notes
    if has_gui; then
        log_info "Remember to:"
        log_info "  - Manually install: Slack, Steam, Chrome (if needed)"
        log_info "  - Configure Syncthing"
        log_info "  - Sign in to 1Password"
    fi
    
    log_info "To change shell to Fish, run: chsh -s $(command -v fish)"
}

# Run main function
main "$@"