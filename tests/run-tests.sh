#!/usr/bin/env bash
# ABOUTME: Test runner script for yadm bootstrap tests
# ABOUTME: Runs all tests and provides summary output

set -euo pipefail

# Colors
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: bats is not installed${NC}"
    echo "Install it with:"
    echo "  Ubuntu/Debian: sudo apt-get install bats"
    echo "  Arch: sudo pacman -S bats"
    echo "  macOS: brew install bats-core"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}Running yadm bootstrap tests...${NC}"
echo

# Run tests
if bats "${SCRIPT_DIR}"/*.bats; then
    echo
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
