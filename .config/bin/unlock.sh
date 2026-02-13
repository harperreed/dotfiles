#!/bin/bash
# ABOUTME: Checks if the macOS login keychain is locked and unlocks it if needed.
# ABOUTME: Supports quiet mode (-q), non-interactive unlock via KEYCHAIN_PASSWORD env var, and post-unlock verification.

set -euo pipefail

# --- Configuration ---
KEYCHAIN="login.keychain-db"
QUIET=false

# --- Colors ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
DIM='\033[2m'
RESET='\033[0m'

# --- Helpers ---
log() { "$QUIET" || echo -e "$@"; }

die() {
    echo -e "💀 ${RED}$1${RESET}" >&2
    exit "${2:-1}"
}

usage() {
    echo -e "${CYAN}🔑 unlock.sh${RESET} — macOS keychain unlocker"
    echo ""
    echo -e "${YELLOW}Usage:${RESET}  unlock.sh [-q] [-h]"
    echo ""
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  ${GREEN}-q${RESET}    Quiet mode (no output on success; useful in scripts)"
    echo -e "  ${GREEN}-h${RESET}    Show this help"
    echo ""
    echo -e "${YELLOW}Environment:${RESET}"
    echo -e "  ${MAGENTA}KEYCHAIN_PASSWORD${RESET}   If set, unlock non-interactively using this value."
    echo -e "                      Useful for automation. Handle with care. 🤫"
    exit 0
}

# --- Parse flags ---
while getopts "qh" opt; do
    case "$opt" in
        q) QUIET=true ;;
        h) usage ;;
        *) usage ;;
    esac
done

# --- Platform guard ---
[[ "$(uname -s)" == "Darwin" ]] || die "🍎 This script only works on macOS"

# --- Verify the security CLI exists ---
command -v security &>/dev/null || die "🔍 security command not found"

# --- Resolve keychain path ---
keychain_path=$(security default-keychain 2>/dev/null | tr -d '[:space:]"')
if [[ -z "$keychain_path" ]]; then
    die "🫠 Could not determine default keychain"
fi

# --- Check lock status ---
# show-keychain-info outputs to stderr; returns non-zero when locked
if security show-keychain-info "$KEYCHAIN" 2>/dev/null; then
    log "🔓 ${GREEN}Keychain is already unlocked${RESET} ✨"

    # Show timeout info unless quiet
    if ! "$QUIET"; then
        timeout_info=$(security show-keychain-info "$KEYCHAIN" 2>&1 || true)
        if echo "$timeout_info" | grep -q "no-timeout"; then
            log "  ${DIM}⏰ auto-lock: disabled — living dangerously 😎${RESET}"
        elif echo "$timeout_info" | grep -q "timeout="; then
            seconds=$(echo "$timeout_info" | sed -n 's/.*timeout=\([0-9]*\).*/\1/p')
            if [[ -n "$seconds" ]]; then
                log "  ${DIM}⏰ auto-lock: ${seconds}s${RESET}"
            fi
        fi
    fi
    exit 0
fi

# --- Keychain is locked; attempt unlock ---
log "🔒 ${YELLOW}Keychain is locked${RESET} — ${BLUE}unlocking...${RESET} 🗝️"

if [[ -n "${KEYCHAIN_PASSWORD:-}" ]]; then
    # Non-interactive unlock
    if ! security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN" 2>/dev/null; then
        die "🚫 Failed to unlock keychain (bad password or keychain error)"
    fi
else
    # Interactive unlock (prompts for password)
    if ! security unlock-keychain "$KEYCHAIN"; then
        die "🚫 Failed to unlock keychain"
    fi
fi

# --- Verify it actually unlocked ---
if ! security show-keychain-info "$KEYCHAIN" 2>/dev/null; then
    die "🤔 Keychain still locked after unlock attempt — spooky"
fi

log "🔓 ${GREEN}Keychain unlocked successfully${RESET} 🎉🥳🍻"
