#!/usr/bin/env fish
# ABOUTME: Enable Blink Shell mode on this system
# ABOUTME: Creates marker file that tells fish config you're using Blink

echo "🔧 Enabling Blink Shell mode..."

# Create marker file
touch ~/.using-blink
chmod 644 ~/.using-blink

echo "✅ Blink mode enabled!"
echo ""
echo "This server will now use Blink-optimized settings:"
echo "  • Compact prompt"
echo "  • Blink-specific aliases (t, tn, tl, m)"
echo "  • Clipboard helpers (copy/paste)"
echo "  • Quick reconnect helpers (wr, wl, wq)"
echo ""
echo "To disable: rm ~/.using-blink"
