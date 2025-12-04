#!/bin/bash


# Try to show keychain info without password prompt
# If it times out or fails, the keychain is locked
if timeout 1 security show-keychain-info &>/dev/null; then
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
