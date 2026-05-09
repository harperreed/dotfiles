#!/bin/bash
# macOS Setup Script - Generated from Harper's defaults
# Run with: bash mac-setup.sh

set -e
echo "🖥️  Configuring macOS preferences..."

# ==============================================================================
# DOCK
# ==============================================================================
echo "→ Dock..."

# Auto-hide dock
defaults write com.apple.dock autohide -bool true

# Dock on the right side
defaults write com.apple.dock orientation -string "right"

# Very small tile size (16px - quite minimal!)
defaults write com.apple.dock tilesize -int 16

# Enable magnification with max size 128
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128

# Scale effect for minimize (faster than genie)
defaults write com.apple.dock mineffect -string "scale"

# Don't auto-rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Hot Corners (5=Screen Saver, 10=Put Display to Sleep, 14=Quick Note)
# Desktop: Screen Saver on TL/TR/BL, Quick Note on BR
# Laptop: Screen Saver on TL/TR, Sleep on BL, Quick Note on BR
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 10  # Put Display to Sleep (laptop-friendly)
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# ==============================================================================
# FINDER
# ==============================================================================
echo "→ Finder..."

# Default to list view (Nlsv = list, icnv = icon, clmv = column, glyv = gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# New Finder windows open to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Show external drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Sidebar width
defaults write com.apple.finder FK_SidebarWidth -int 150

# ==============================================================================
# iCLOUD
# ==============================================================================
echo "→ iCloud (requires sign-in first)..."

# Enable iCloud Drive with Desktop & Documents sync
defaults write com.apple.finder FXICloudDriveEnabled -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool true
defaults write com.apple.finder FXICloudDriveDocuments -bool true

# ==============================================================================
# KEYBOARD & INPUT
# ==============================================================================
echo "→ Keyboard..."

# Auto dark mode switching
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Keep auto-capitalization and period substitution
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys (enable proper key repeat)
# Without this, holding a key shows accent picker instead of repeating
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ==============================================================================
# TRACKPAD
# ==============================================================================
echo "→ Trackpad..."

# No tap-to-click, no three-finger drag
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false

# Force click enabled
defaults write NSGlobalDomain "com.apple.trackpad.forceClick" -bool true

# Gestures
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2

# ==============================================================================
# APPEARANCE
# ==============================================================================
echo "→ Appearance..."

# Enable wallpaper tinting in windows (Sequoia)
defaults write NSGlobalDomain NSGlassDiffusionSetting -int 1

# ==============================================================================
# SCREENSHOTS
# ==============================================================================
echo "→ Screenshots..."

mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ==============================================================================
# REDUCE CRUFT
# ==============================================================================
echo "→ Reducing cruft..."

# Disable .DS_Store on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable quarantine "Are you sure?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ==============================================================================
# QUALITY OF LIFE
# ==============================================================================
echo "→ Quality of life..."

# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Keep windows when quitting apps
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

# ==============================================================================
# APPLY CHANGES
# ==============================================================================
echo ""
echo "Restarting affected services..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

# ==============================================================================
# MANUAL STEPS
# ==============================================================================
echo ""
echo "✅ Done! Some changes may require logout/restart."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MANUAL STEPS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Sign into iCloud (System Settings > Apple Account)"
echo "   - Enable: iCloud Drive, Photos, Keychain, Find My Mac"
echo "   - Desktop & Documents sync will activate after sign-in"
echo ""
echo "2. Security (System Settings > Privacy & Security)"
echo "   - Enable FileVault"
echo "   - Enable Firewall"
echo ""
echo "3. Text Replacements"
echo "   Your shortcuts (shrug, fliptable, disapprove, etc.) need to be imported."
echo "   If you exported from old machine:"
echo "     defaults import NSGlobalDomain ~/global_prefs.plist"
echo "   Or manually add in: System Settings > Keyboard > Text Replacements"
echo ""
echo "4. Dock Apps (add manually or via dockutil)"
echo "   Desktop: Helium, Beeper, Ghostty, Slack, Granola"
echo "   Laptop:  Beeper, Drafts, ChatGPT, Helium, Ghostty"
echo ""
echo "5. Tailscale"
echo "   - Install from App Store or tailscale.com"
echo "   - Enable 'Start on Login' in menu bar settings"
echo ""

