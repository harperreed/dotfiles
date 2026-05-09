#!/bin/bash
# ABOUTME: macOS optimizations for low-RAM machines (8GB or less).
# ABOUTME: Run after set-defaults.sh — only on memory-constrained machines.

set -e
UID_NUM=$(id -u)

echo "Configuring low-RAM optimizations..."

# ==============================================================================
# TIER 1: DISABLE BACKGROUND LEECHES
# ==============================================================================
echo "→ Disabling background processes..."

# Spotify auto-launch
launchctl disable "gui/$UID_NUM/com.spotify.client.startuphelper" 2>/dev/null || true

# Zoom daemon + updaters (3 plists)
sudo launchctl disable system/us.zoom.ZoomDaemon 2>/dev/null || true
launchctl disable "gui/$UID_NUM/us.zoom.updater" 2>/dev/null || true
launchctl disable "gui/$UID_NUM/us.zoom.updater.login.check" 2>/dev/null || true

# OpenAI chat helper
launchctl disable "gui/$UID_NUM/com.openai.chat-helper" 2>/dev/null || true

# Helium updater processes
launchctl disable "gui/$UID_NUM/net.imput.helium-sparkle-updater" 2>/dev/null || true
launchctl disable "gui/$UID_NUM/net.imput.helium-sparkle-progress" 2>/dev/null || true

# ==============================================================================
# TIER 2: REDUCE SYSTEM OVERHEAD
# ==============================================================================
echo "→ Reducing visual overhead..."

# Reduce transparency (fewer compositing layers for WindowServer)
defaults write com.apple.universalaccess reduceTransparency -bool true

# Reduce motion (fewer animation frames held in memory)
defaults write com.apple.universalaccess reduceMotion -bool true

# Disable wallpaper tinting (overrides set-defaults.sh glass diffusion)
defaults write NSGlobalDomain NSGlassDiffusionSetting -int 0

echo "→ Window management..."

# Disable window resume (prevents storing window state blobs in memory)
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

echo "→ Spotlight..."

# Disable Spotlight indexing on external volumes (mdworker is a RAM pig)
sudo mdutil -i off /Volumes/* 2>/dev/null || true

# Reduce Spotlight indexing scope — disable categories that spawn mdworker_shared
# Keep: Applications, System Preferences, Calculator, Folders, Documents
# Disable: heavy indexers like Mail, Messages, Fonts, Music, etc.
defaults write com.apple.spotlight orderedItems -array \
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

# ==============================================================================
# REPORT
# ==============================================================================
echo ""
echo "Currently loaded non-Apple launch agents:"
launchctl list | grep -v "com.apple" | grep -v "PID" | awk '{print "  " $3}' | sort

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
