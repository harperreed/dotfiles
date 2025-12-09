#!/bin/bash
# ABOUTME: Common functions and utilities for bootstrap scripts
# ABOUTME: Provides logging, error handling, and shared functionality

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuration
readonly LOG_FILE="${LOG_FILE:-$HOME/.config/yadm/bootstrap.log}"
readonly DRY_RUN="${DRY_RUN:-false}"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging functions
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Log to console with color
    case $level in
        ERROR)   echo -e "${RED}[ERROR]${NC} $message" >&2 ;;
        WARN)    echo -e "${YELLOW}[WARN]${NC} $message" >&2 ;;
        INFO)    echo -e "${BLUE}[INFO]${NC} $message" ;;
        SUCCESS) echo -e "${GREEN}[SUCCESS]${NC} $message" ;;
        *)       echo "[$level] $message" ;;
    esac
}

log_error() { log ERROR "$@"; }
log_warn() { log WARN "$@"; }
log_info() { log INFO "$@"; }
log_success() { log SUCCESS "$@"; }

# Error handling
die() {
    log_error "$@"
    exit 1
}

# Dry run wrapper
run_command() {
    local cmd="$*"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would execute: $cmd"
        return 0
    fi
    
    log_info "Executing: $cmd"
    if ! eval "$cmd"; then
        log_error "Command failed: $cmd"
        return 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if file exists and is readable
file_exists() {
    [[ -f "$1" && -r "$1" ]]
}

# Check if directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Prompt for confirmation
confirm() {
    local prompt="${1:-Continue?}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would prompt: $prompt"
        return 0
    fi
    
    read -r -p "$prompt [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# Check if running with sudo (when needed)
require_sudo() {
    if [[ $EUID -eq 0 ]]; then
        log_warn "This script should not be run as root directly"
        return 1
    fi
    
    if ! sudo -n true 2>/dev/null; then
        log_info "This operation requires sudo privileges"
        sudo -v
    fi
}

# Platform detection
detect_platform() {
    local system_type=$(uname -s)
    local arch_type=$(uname -m)

    echo "${system_type}_${arch_type}"
}

# Detect Linux distribution
detect_linux_distro() {
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot detect Linux distribution: /etc/os-release not found"
        return 1
    fi

    # Read ID from os-release
    local distro=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    echo "$distro"
}

# Check if distribution is Debian-based
is_debian_based() {
    local distro="${1:-$(detect_linux_distro)}"
    case "$distro" in
        debian|ubuntu|linuxmint|pop|elementary)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if distribution is Arch-based
is_arch_based() {
    local distro="${1:-$(detect_linux_distro)}"
    case "$distro" in
        arch|manjaro|endeavouros)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Version comparison
version_gte() {
    # Returns 0 if $1 >= $2
    printf '%s\n%s' "$2" "$1" | sort -V -C
}

# Backup file before modification
backup_file() {
    local file="$1"
    local backup="${file}.yadm-backup.$(date +%Y%m%d_%H%M%S)"
    
    if file_exists "$file"; then
        log_info "Backing up $file to $backup"
        cp "$file" "$backup"
    fi
}

# Create symlink safely
safe_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -L "$target" ]]; then
        local current_source=$(readlink "$target")
        if [[ "$current_source" == "$source" ]]; then
            log_info "Symlink already exists: $target -> $source"
            return 0
        else
            log_warn "Symlink exists but points elsewhere: $target -> $current_source"
            if confirm "Replace with $source?"; then
                run_command "rm -f '$target'"
            else
                return 1
            fi
        fi
    elif [[ -e "$target" ]]; then
        log_warn "Target exists and is not a symlink: $target"
        if confirm "Backup and replace with symlink?"; then
            backup_file "$target"
            run_command "rm -f '$target'"
        else
            return 1
        fi
    fi
    
    run_command "ln -sf '$source' '$target'"
    log_success "Created symlink: $target -> $source"
}

# Idempotent package installation checker
is_package_installed() {
    local package="$1"
    local platform=$(detect_platform)

    case $platform in
        Darwin_*)
            if command_exists brew; then
                brew list "$package" &>/dev/null
            else
                return 1
            fi
            ;;
        Linux_*)
            local distro=$(detect_linux_distro)
            if is_debian_based "$distro"; then
                dpkg -l "$package" 2>/dev/null | grep -q "^ii"
            elif is_arch_based "$distro"; then
                pacman -Q "$package" &>/dev/null
            else
                log_warn "Unknown Linux distribution for package check: $distro"
                return 1
            fi
            ;;
        *)
            log_warn "Unknown platform for package check: $platform"
            return 1
            ;;
    esac
}

# Add to shell RC file idempotently
add_to_shell_rc() {
    local line="$1"
    local rc_file="${2:-$HOME/.bashrc}"
    
    if ! file_exists "$rc_file"; then
        log_info "Creating $rc_file"
        touch "$rc_file"
    fi
    
    if grep -Fxq "$line" "$rc_file"; then
        log_info "Line already exists in $rc_file: $line"
    else
        backup_file "$rc_file"
        echo "$line" >> "$rc_file"
        log_success "Added to $rc_file: $line"
    fi
}

# Progress indicator
show_progress() {
    local current=$1
    local total=$2
    local task="${3:-Processing}"
    
    local percent=$((current * 100 / total))
    local completed=$((percent / 2))
    local remaining=$((50 - completed))
    
    printf "\r%s: [%s%s] %d%%" \
        "$task" \
        "$(printf '#%.0s' $(seq 1 $completed))" \
        "$(printf ' %.0s' $(seq 1 $remaining))" \
        "$percent"
    
    if [[ $current -eq $total ]]; then
        echo
    fi
}

# Cleanup function
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Bootstrap failed with exit code: $exit_code"
        log_info "Check log file: $LOG_FILE"
    else
        log_success "Bootstrap completed successfully"
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# Export functions for use in other scripts
export -f log log_error log_warn log_info log_success
export -f die run_command command_exists file_exists dir_exists
export -f confirm require_sudo detect_platform version_gte
export -f backup_file safe_symlink is_package_installed
export -f add_to_shell_rc show_progress
export -f detect_linux_distro is_debian_based is_arch_based