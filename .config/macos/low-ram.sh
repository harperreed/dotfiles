#!/bin/bash
# ABOUTME: macOS optimizations for low-RAM machines (8GB or less).
# ABOUTME: Run after set-defaults.sh — only on memory-constrained machines.

set -euo pipefail

UID_NUM=$(id -u)
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: low-ram.sh [--dry-run|-n]

Options:
  -n, --dry-run    Print mutating commands without executing them.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

log() {
  echo "$1"
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

require_sudo() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log "Dry run mode: skipping sudo authentication."
  else
    sudo -v
  fi
}

disable_service() {
  local target="$1"

  # Prevent future auto-start and stop the service if it is currently loaded.
  run launchctl disable "$target" 2>/dev/null || true
  run launchctl bootout "$target" 2>/dev/null || true
}

is_external_volume() {
  local volume="$1"

  [[ -d "$volume" ]] || return 1

  [[ "$(diskutil info -plist "$volume" 2>/dev/null | plutil -extract RemovableMediaOrExternalDevice raw -o - - 2>/dev/null || echo false)" == "true" ]]
}

disable_external_spotlight() {
  local volume

  shopt -s nullglob
  for volume in /Volumes/*; do
    is_external_volume "$volume" || continue
    run sudo mdutil -i off "$volume" 2>/dev/null || true
  done
  shopt -u nullglob
}

report_external_spotlight() {
  local volume

  shopt -s nullglob
  for volume in /Volumes/*; do
    is_external_volume "$volume" || continue
    mdutil -s "$volume" 2>/dev/null || true
  done
  shopt -u nullglob
}

require_sudo

log "Configuring low-RAM optimizations..."

# ==============================================================================
# TIER 1: DISABLE BACKGROUND LEECHES
# ==============================================================================
log "→ Disabling background processes..."

# Spotify auto-launch
disable_service "gui/$UID_NUM/com.spotify.client.startuphelper"

# Zoom daemon + updaters (3 plists)
run sudo launchctl disable system/us.zoom.ZoomDaemon 2>/dev/null || true
run sudo launchctl bootout system/us.zoom.ZoomDaemon 2>/dev/null || true
disable_service "gui/$UID_NUM/us.zoom.updater"
disable_service "gui/$UID_NUM/us.zoom.updater.login.check"

# OpenAI chat helper
disable_service "gui/$UID_NUM/com.openai.chat-helper"

# Helium updater processes
disable_service "gui/$UID_NUM/net.imput.helium-sparkle-updater"
disable_service "gui/$UID_NUM/net.imput.helium-sparkle-progress"

# ==============================================================================
# TIER 2: REDUCE SYSTEM OVERHEAD
# ==============================================================================
log "→ Reducing visual overhead..."

# Reduce transparency to cut visual effects overhead.
run defaults write com.apple.universalaccess reduceTransparency -bool true

# Reduce motion to limit animation churn.
run defaults write com.apple.universalaccess reduceMotion -bool true

# Disable wallpaper tinting (overrides set-defaults.sh glass diffusion).
run defaults write NSGlobalDomain NSGlassDiffusionSetting -int 0

log "→ Window management..."

# Disable window resume so apps do not reopen previous window sets by default.
run defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

log "→ Spotlight..."

# Disable Spotlight indexing on currently mounted external volumes.
disable_external_spotlight

# Rewriting Spotlight categories is mostly a search-preference choice, not a
# proven RAM optimization. Leave it opt-in so the script stays conservative.
if [[ "${LOW_RAM_REWRITE_SPOTLIGHT_CATEGORIES:-0}" == "1" ]]; then
  log "→ Rewriting Spotlight categories (opt-in)..."
  run defaults write com.apple.spotlight orderedItems -array \
    '{ enabled = 1; name = APPLICATIONS; }' \
    '{ enabled = 1; name = "SYSTEM_PREFS"; }' \
    '{ enabled = 1; name = DIRECTORIES; }' \
    '{ enabled = 1; name = DOCUMENTS; }' \
    '{ enabled = 1; name = "SOURCE"; }' \
    '{ enabled = 0; name = FONTS; }' \
    '{ enabled = 0; name = "MESSAGES"; }' \
    '{ enabled = 0; name = "CONTACT"; }' \
    '{ enabled = 0; name = "EVENT_TODO"; }' \
    '{ enabled = 0; name = IMAGES; }' \
    '{ enabled = 0; name = BOOKMARKS; }' \
    '{ enabled = 0; name = MUSIC; }' \
    '{ enabled = 0; name = MOVIES; }' \
    '{ enabled = 0; name = PRESENTATIONS; }' \
    '{ enabled = 0; name = SPREADSHEETS; }' \
    '{ enabled = 0; name = "PDF"; }'
else
  log "→ Leaving Spotlight category order unchanged."
fi

# ==============================================================================
# REPORT
# ==============================================================================
echo ""
echo "Disabled launch services:"
launchctl print-disabled "gui/$UID_NUM" 2>/dev/null | grep -E "spotify|zoom|openai|helium" || true
if [[ "$DRY_RUN" == "1" ]]; then
  echo "  (dry run: skipped system launchctl verification)"
else
  sudo launchctl print-disabled system 2>/dev/null | grep -i "zoom" || true
fi

echo ""
echo "Spotlight status for mounted external volumes:"
report_external_spotlight

echo ""
echo "Currently loaded non-Apple launch agents:"
launchctl list | grep -v "com.apple" | grep -v "PID" | awk '{print "  " $3}' | sort || true

echo ""
echo "Done. Some changes require logout/restart."
echo ""
echo "MANUAL STEPS (Tier 3 — behavioral):"
echo "  1. You're already using Claude CLI — consider quitting Claude Desktop (~230 MB)"
echo "  2. Beeper eats ~760 MB when open — use phone when possible"
echo "  3. Each Helium/browser tab is a separate process (~50-90 MB each)"
echo "  4. Quit apps you're not actively using — don't just minimize"
echo "  5. System Settings > Accessibility > Display"
echo "     - Verify 'Reduce transparency' and 'Reduce motion' are on"
