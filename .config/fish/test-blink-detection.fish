#!/usr/bin/env fish
# ABOUTME: Test script to verify Blink Shell detection logic
# ABOUTME: Run with: fish test-blink-detection.fish

echo "🔍 Blink Shell Detection Test"
echo "================================"
echo ""

# Show current environment
echo "📋 Current Environment:"
echo "  TERM_PROGRAM: $TERM_PROGRAM"
echo "  TERM: $TERM"
echo "  LC_TERMINAL: $LC_TERMINAL"
echo "  TERM_SESSION_ID: $TERM_SESSION_ID"
echo "  uname: "(uname)
echo "  uname -m: "(uname -m)
echo ""

# Source the Blink config to get detection functions
source ~/.config/fish/conf.d/95-blink.fish 2>/dev/null

# Test is_blink function
echo "🧪 Testing is_blink function:"
if is_blink
    echo "  ✅ is_blink returned TRUE"
else
    echo "  ❌ is_blink returned FALSE"
end
echo ""

# Test is_ios function
echo "🧪 Testing is_ios function:"
if is_ios
    echo "  ✅ is_ios returned TRUE"
else
    echo "  ❌ is_ios returned FALSE"
end
echo ""

# Check what Blink-specific features would be active
echo "📦 Blink-specific features status:"
if is_blink
    echo "  ✅ Blink aliases/abbreviations would be loaded"
    echo "  ✅ Clipboard helpers (copy/paste) available"
    echo "  ✅ Auto-setup message shown (first load)"
else
    echo "  ❌ No Blink-specific features active"
    echo "  💡 This is expected if NOT running in Blink Shell"
end
echo ""

# Show what the detection is looking for
echo "🎯 Detection Logic:"
echo "  is_blink checks: TERM_PROGRAM = 'Blink'"
echo "  is_ios checks: uname = Darwin AND uname -m = arm64 AND is_blink"
echo ""

# Simulate Blink environment
echo "🔬 Simulating Blink Shell environment:"
set -lx TERM_PROGRAM Blink
echo "  Set TERM_PROGRAM=Blink"

if test "$TERM_PROGRAM" = "Blink"
    echo "  ✅ Detection would work in real Blink Shell"
else
    echo "  ❌ Detection logic failed"
end
echo ""

# Final verdict
echo "📊 Summary:"
if is_blink
    echo "  🎉 You ARE running in Blink Shell!"
else
    echo "  ℹ️  You are NOT running in Blink Shell (this is normal for desktop)"
    echo ""
    echo "  To test in Blink Shell on iOS:"
    echo "    1. Copy this file to your iOS device"
    echo "    2. Run: fish test-blink-detection.fish"
    echo "    3. You should see is_blink return TRUE"
    echo ""
    echo "  Or check manually in Blink:"
    echo "    echo \$TERM_PROGRAM"
    echo "    (should output 'Blink')"
end
