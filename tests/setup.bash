#!/usr/bin/env bash
# ABOUTME: Setup file for bats tests - loads common functions and sets up test environment
# ABOUTME: Provides mocking utilities and test helpers for bootstrap tests

# Get the directory containing the bootstrap scripts
export BOOTSTRAP_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.config/yadm" && pwd)"
export BOOTSTRAP_D_DIR="${BOOTSTRAP_DIR}/bootstrap.d"

# Set test mode environment variables
export DRY_RUN="true"
export LOG_FILE="${BATS_TMPDIR}/test-bootstrap.log"
export SUDO_ASKPASS="/bin/false"

# Mock sudo to avoid actual sudo calls in tests
sudo() {
    if [[ "$1" == "-n" ]]; then
        # Simulate sudo -n true succeeding
        return 0
    fi
    echo "[MOCK SUDO] $*"
}
export -f sudo

# Mock apt-get
apt-get() {
    echo "[MOCK APT-GET] $*"
}
export -f apt-get

# Mock pacman
pacman() {
    echo "[MOCK PACMAN] $*"
}
export -f pacman

# Mock dpkg
dpkg() {
    if [[ "$1" == "-l" ]]; then
        # Simulate package not installed
        return 1
    elif [[ "$1" == "--print-architecture" ]]; then
        echo "amd64"
    fi
}
export -f dpkg

# Helper to source common functions
load_common() {
    source "${BOOTSTRAP_D_DIR}/common.sh"
}
