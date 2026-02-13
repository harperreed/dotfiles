#!/bin/bash
# ABOUTME: Checks if the macOS keychain is locked and unlocks it if needed.
# ABOUTME: Uses security CLI to inspect and unlock the default keychain.

# show-keychain-info returns non-zero when locked, no timeout needed
if security show-keychain-info &>/dev/null; then
    echo "✓ Keychain is already unlocked"
else
    echo "✗ Keychain is locked - unlocking..."
    security unlock-keychain
    
    if [ $? -eq 0 ]; then
        echo "✓ Keychain unlocked successfully"
    else
        echo "✗ Failed to unlock keychain"
        exit 1
    fi
fi
