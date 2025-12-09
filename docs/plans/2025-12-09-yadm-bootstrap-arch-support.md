# YADM Bootstrap Arch Support Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Arch Linux support to yadm bootstrap system and create comprehensive tests for Ubuntu/Debian bootstrap functionality.

**Architecture:** Refactor linux.sh to detect Linux distribution (Debian/Ubuntu vs Arch) and dispatch to distro-specific functions. Add distro detection to common.sh. Create comprehensive test suite using bats-core for testing shell scripts with TDD approach.

**Tech Stack:**
- Bash shell scripting
- bats-core (Bash Automated Testing System)
- apt (Debian/Ubuntu package manager)
- pacman (Arch package manager)

---

## Task 1: Setup Testing Infrastructure

**Files:**
- Create: `tests/README.md`
- Create: `tests/setup.bash`
- Create: `.gitignore` (modify if exists)

**Step 1: Create tests directory structure**

```bash
mkdir -p tests
```

**Step 2: Create test setup file**

Create `tests/setup.bash`:

```bash
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
```

**Step 3: Create tests README**

Create `tests/README.md`:

```markdown
# YADM Bootstrap Tests

This directory contains tests for the yadm bootstrap scripts.

## Running Tests

### Install bats-core

**Ubuntu/Debian:**
```bash
sudo apt-get install bats
```

**Arch:**
```bash
sudo pacman -S bats
```

**macOS:**
```bash
brew install bats-core
```

### Run all tests

```bash
bats tests/
```

### Run specific test file

```bash
bats tests/test_common.bats
```

## Test Structure

- `setup.bash` - Common setup and mocking utilities
- `test_common.bats` - Tests for common.sh functions
- `test_debian_bootstrap.bats` - Tests for Debian/Ubuntu bootstrap
- `test_arch_bootstrap.bats` - Tests for Arch Linux bootstrap
- `test_main_bootstrap.bats` - Tests for main bootstrap dispatcher
```

**Step 4: Update .gitignore**

If `.gitignore` exists, add these lines (if not already present):

```
# Test artifacts
tests/*.log
*.log
```

If it doesn't exist, create it with just those lines.

**Step 5: Commit**

```bash
git add tests/setup.bash tests/README.md .gitignore
git commit -m "test: add testing infrastructure for bootstrap scripts"
```

---

## Task 2: Add Distribution Detection to common.sh

**Files:**
- Modify: `.config/yadm/bootstrap.d/common.sh`
- Create: `tests/test_common.bats`

**Step 1: Write failing test for distro detection**

Create `tests/test_common.bats`:

```bash
#!/usr/bin/env bats

load setup

@test "detect_linux_distro detects debian" {
    load_common

    # Mock /etc/os-release for Debian
    export MOCK_OS_RELEASE="ID=debian"

    # Override file reading
    detect_linux_distro() {
        if [[ -f /etc/os-release ]]; then
            echo "$MOCK_OS_RELEASE" | grep "^ID=" | cut -d= -f2 | tr -d '"'
        fi
    }

    result=$(detect_linux_distro)
    [ "$result" = "debian" ]
}

@test "detect_linux_distro detects ubuntu" {
    load_common

    export MOCK_OS_RELEASE="ID=ubuntu"

    detect_linux_distro() {
        echo "$MOCK_OS_RELEASE" | grep "^ID=" | cut -d= -f2 | tr -d '"'
    }

    result=$(detect_linux_distro)
    [ "$result" = "ubuntu" ]
}

@test "detect_linux_distro detects arch" {
    load_common

    export MOCK_OS_RELEASE="ID=arch"

    detect_linux_distro() {
        echo "$MOCK_OS_RELEASE" | grep "^ID=" | cut -d= -f2 | tr -d '"'
    }

    result=$(detect_linux_distro)
    [ "$result" = "arch" ]
}

@test "is_debian_based returns true for debian" {
    load_common

    # Will fail until we implement it
    is_debian_based "debian"
}

@test "is_debian_based returns true for ubuntu" {
    load_common

    is_debian_based "ubuntu"
}

@test "is_debian_based returns false for arch" {
    load_common

    ! is_debian_based "arch"
}

@test "is_arch_based returns true for arch" {
    load_common

    is_arch_based "arch"
}

@test "is_arch_based returns false for debian" {
    load_common

    ! is_arch_based "debian"
}
```

**Step 2: Run tests to verify they fail**

```bash
bats tests/test_common.bats
```

Expected: Multiple test failures because functions don't exist yet.

**Step 3: Implement distro detection in common.sh**

Add these functions to `.config/yadm/bootstrap.d/common.sh` after the `detect_platform` function (around line 118):

```bash
# Detect Linux distribution
detect_linux_distro() {
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot detect Linux distribution: /etc/os-release not found"
        return 1
    fi

    # Read ID from os-release
    local distro=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    echo "$distro"
}

# Check if distribution is Debian-based
is_debian_based() {
    local distro="${1:-$(detect_linux_distro)}"
    case "$distro" in
        debian|ubuntu|linuxmint|pop|elementary)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if distribution is Arch-based
is_arch_based() {
    local distro="${1:-$(detect_linux_distro)}"
    case "$distro" in
        arch|manjaro|endeavouros)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
```

**Step 4: Update is_package_installed to support both Debian and Arch**

Replace the `is_package_installed` function in `common.sh` (around line 170):

```bash
# Idempotent package installation checker
is_package_installed() {
    local package="$1"
    local platform=$(detect_platform)

    case $platform in
        Darwin_*)
            if command_exists brew; then
                brew list "$package" &>/dev/null
            else
                return 1
            fi
            ;;
        Linux_*)
            local distro=$(detect_linux_distro)
            if is_debian_based "$distro"; then
                dpkg -l "$package" 2>/dev/null | grep -q "^ii"
            elif is_arch_based "$distro"; then
                pacman -Q "$package" &>/dev/null
            else
                log_warn "Unknown Linux distribution for package check: $distro"
                return 1
            fi
            ;;
        *)
            log_warn "Unknown platform for package check: $platform"
            return 1
            ;;
    esac
}
```

**Step 5: Export new functions**

Update the export line at the end of `common.sh` (around line 250):

```bash
export -f detect_linux_distro is_debian_based is_arch_based
```

**Step 6: Run tests to verify they pass**

```bash
bats tests/test_common.bats
```

Expected: All tests pass.

**Step 7: Commit**

```bash
git add .config/yadm/bootstrap.d/common.sh tests/test_common.bats
git commit -m "feat: add Linux distribution detection to common.sh

- Add detect_linux_distro to identify Debian/Ubuntu/Arch
- Add is_debian_based and is_arch_based helper functions
- Update is_package_installed to support both apt and pacman
- Add comprehensive tests for distribution detection"
```

---

## Task 3: Refactor linux.sh to Support Multiple Distributions

**Files:**
- Modify: `.config/yadm/bootstrap.d/linux.sh`
- Create: `tests/test_debian_bootstrap.bats`

**Step 1: Write test for Debian bootstrap entry point**

Create `tests/test_debian_bootstrap.bats`:

```bash
#!/usr/bin/env bats

load setup

@test "bootstrap_debian function exists" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    # Check function is defined
    declare -f bootstrap_debian
}

@test "bootstrap_debian updates apt" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    # This will fail until we refactor
    run bootstrap_debian

    # Should see apt update in output
    [[ "$output" =~ "apt-get update" ]]
}
```

**Step 2: Run test to verify it fails**

```bash
bats tests/test_debian_bootstrap.bats
```

Expected: FAIL - function doesn't exist yet.

**Step 3: Refactor linux.sh main function**

Replace the `main` function in `.config/yadm/bootstrap.d/linux.sh` (around line 310):

```bash
# Debian/Ubuntu bootstrap
bootstrap_debian() {
    log_info "Running Debian/Ubuntu bootstrap"

    # Initial update
    update_apt

    # Install base packages
    log_info "Installing base packages"
    install_packages "${BASE_PACKAGES[@]}"

    # Install additional tools
    install_uv
    install_mise
    install_atuin

    # GUI-specific setup
    if has_gui; then
        log_info "GUI environment detected"

        # Install GUI packages
        log_info "Installing GUI packages"
        install_packages "${GUI_PACKAGES[@]}"

        # Setup repositories
        setup_repositories
        update_apt

        # Install repository packages
        local repo_packages=(code syncthing 1password)
        install_packages "${repo_packages[@]}"

        # Configure 1Password
        configure_1password

        # Install Discord
        install_discord
    else
        log_info "Headless environment detected, skipping GUI packages"

        # Still install some repositories for headless
        add_apt_repository \
            "tailscale" \
            "https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg" \
            "deb [signed-by=$APT_KEYRINGS_DIR/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main"

        update_apt
        install_packages tailscale nodejs
    fi

    # Configure Fish shell
    configure_fish_shell

    # Cleanup
    if confirm "Clean up package cache?"; then
        run_command "sudo apt-get autoremove -y"
        run_command "sudo apt-get autoclean"
    fi

    log_success "Debian/Ubuntu bootstrap completed"

    # Final notes
    if has_gui; then
        log_info "Remember to:"
        log_info "  - Manually install: Slack, Steam, Chrome (if needed)"
        log_info "  - Configure Syncthing"
        log_info "  - Sign in to 1Password"
    fi

    log_info "To change shell to Fish, run: chsh -s $(command -v fish)"
}

# Arch Linux bootstrap
bootstrap_arch() {
    log_info "Running Arch Linux bootstrap"

    # Update package database
    update_pacman

    # Install base packages
    log_info "Installing base packages"
    install_packages_arch "${ARCH_BASE_PACKAGES[@]}"

    # Install additional tools
    install_uv
    install_mise
    install_atuin

    # GUI-specific setup
    if has_gui; then
        log_info "GUI environment detected"

        # Install GUI packages
        log_info "Installing GUI packages"
        install_packages_arch "${ARCH_GUI_PACKAGES[@]}"

        # Install AUR packages if yay is available
        if command_exists yay; then
            install_aur_packages
        else
            log_warn "yay not found, skipping AUR packages"
            log_info "Install yay to enable AUR package installation"
        fi
    else
        log_info "Headless environment detected, skipping GUI packages"
    fi

    # Configure Fish shell
    configure_fish_shell

    # Cleanup
    if confirm "Clean up package cache?"; then
        run_command "sudo pacman -Sc --noconfirm"
    fi

    log_success "Arch Linux bootstrap completed"

    # Final notes
    if has_gui; then
        log_info "Remember to:"
        log_info "  - Manually install AUR packages if yay not installed"
        log_info "  - Configure Syncthing"
        log_info "  - Sign in to 1Password"
    fi

    log_info "To change shell to Fish, run: chsh -s $(command -v fish)"
}

# Main Linux bootstrap
main() {
    log_info "Linux bootstrap started"

    # Check if running on Linux
    if [[ "$(uname -s)" != "Linux" ]]; then
        die "This script is for Linux only"
    fi

    # Detect distribution
    local distro=$(detect_linux_distro)
    log_info "Detected distribution: $distro"

    # Dispatch to appropriate bootstrap
    if is_debian_based "$distro"; then
        # Check Debian version
        if [[ ! -f /etc/debian_version ]]; then
            log_warn "Debian-based but no /etc/debian_version found"
        fi
        bootstrap_debian
    elif is_arch_based "$distro"; then
        bootstrap_arch
    else
        die "Unsupported Linux distribution: $distro"
    fi
}

# Run main function
main "$@"
```

**Step 4: Add Arch-specific package arrays**

Add after the GUI_PACKAGES array (around line 41):

```bash
# Arch base packages (equivalents to Debian packages)
readonly ARCH_BASE_PACKAGES=(
    fish
    yadm
    figlet
    lolcat
    fortune-mod
    speedtest-cli
    bsd-games
    go
    neovim
    curl
    wget
    git
    htop
    base-devel
)

# Arch GUI packages
readonly ARCH_GUI_PACKAGES=(
    kitty
    remmina
    gvim
)
```

**Step 5: Add Arch package management functions**

Add these functions before `bootstrap_debian` (around line 280):

```bash
# Update pacman package database
update_pacman() {
    log_info "Updating package database"
    require_sudo
    run_command "sudo pacman -Sy"
}

# Install packages with pacman
install_packages_arch() {
    local packages=("$@")
    local failed_packages=()

    for package in "${packages[@]}"; do
        if is_package_installed "$package"; then
            log_info "Package already installed: $package"
        else
            log_info "Installing package: $package"
            if ! run_command "sudo pacman -S --noconfirm '$package'"; then
                failed_packages+=("$package")
                log_error "Failed to install: $package"
            fi
        fi
    done

    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_error "Failed to install packages: ${failed_packages[*]}"
        return 1
    fi

    return 0
}

# Install AUR packages (requires yay)
install_aur_packages() {
    log_info "Installing AUR packages"

    local aur_packages=(
        visual-studio-code-bin
        1password
        syncthing
        discord
    )

    for package in "${aur_packages[@]}"; do
        if command_exists "$package"; then
            log_info "AUR package already installed: $package"
        else
            log_info "Installing AUR package: $package"
            if ! run_command "yay -S --noconfirm '$package'"; then
                log_error "Failed to install AUR package: $package"
            fi
        fi
    done
}
```

**Step 6: Run tests to verify they pass**

```bash
bats tests/test_debian_bootstrap.bats
```

Expected: All tests pass.

**Step 7: Commit**

```bash
git add .config/yadm/bootstrap.d/linux.sh tests/test_debian_bootstrap.bats
git commit -m "feat: refactor linux.sh to support Debian and Arch

- Split main into bootstrap_debian and bootstrap_arch
- Add Arch package management functions (update_pacman, install_packages_arch)
- Add Arch package arrays for base and GUI packages
- Add AUR package installation support via yay
- Dispatch to correct bootstrap based on detected distro
- Add tests for Debian bootstrap"
```

---

## Task 4: Add Tests for Arch Bootstrap

**Files:**
- Create: `tests/test_arch_bootstrap.bats`

**Step 1: Write tests for Arch bootstrap**

Create `tests/test_arch_bootstrap.bats`:

```bash
#!/usr/bin/env bats

load setup

@test "bootstrap_arch function exists" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    declare -f bootstrap_arch
}

@test "bootstrap_arch updates pacman" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run bootstrap_arch

    # Should see pacman update in output
    [[ "$output" =~ "pacman -Sy" ]]
}

@test "update_pacman runs pacman -Sy" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run update_pacman

    [[ "$output" =~ "pacman -Sy" ]]
}

@test "install_packages_arch installs packages" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run install_packages_arch "fish" "neovim"

    [[ "$output" =~ "pacman -S" ]]
    [[ "$output" =~ "fish" ]]
    [[ "$output" =~ "neovim" ]]
}

@test "install_aur_packages requires yay" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    # Mock command_exists to return false for yay
    command_exists() {
        [[ "$1" != "yay" ]]
    }
    export -f command_exists

    run install_aur_packages

    # Should skip AUR packages
    [[ "$output" =~ "yay" ]]
}
```

**Step 2: Run tests to verify they pass**

```bash
bats tests/test_arch_bootstrap.bats
```

Expected: All tests pass.

**Step 3: Commit**

```bash
git add tests/test_arch_bootstrap.bats
git commit -m "test: add comprehensive tests for Arch bootstrap"
```

---

## Task 5: Add Integration Tests for Main Bootstrap

**Files:**
- Create: `tests/test_main_bootstrap.bats`

**Step 1: Write integration tests**

Create `tests/test_main_bootstrap.bats`:

```bash
#!/usr/bin/env bats

load setup

@test "main bootstrap script exists and is executable" {
    [ -x "${BOOTSTRAP_DIR}/bootstrap" ]
}

@test "bootstrap detects Darwin platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform darwin

    [ "$status" -eq 0 ]
    [[ "$output" =~ "darwin" ]]
}

@test "bootstrap detects Linux platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform linux

    [ "$status" -eq 0 ]
    [[ "$output" =~ "linux" ]]
}

@test "bootstrap shows help" {
    run "${BOOTSTRAP_DIR}/bootstrap" --help

    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "bootstrap dry-run mode works" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run

    [ "$status" -eq 0 ]
    [[ "$output" =~ "DRY RUN" ]]
}

@test "bootstrap fails on unsupported platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform windows

    # Should fail because windows script doesn't exist
    [ "$status" -ne 0 ]
}
```

**Step 2: Run tests**

```bash
bats tests/test_main_bootstrap.bats
```

Expected: All tests pass.

**Step 3: Commit**

```bash
git add tests/test_main_bootstrap.bats
git commit -m "test: add integration tests for main bootstrap dispatcher"
```

---

## Task 6: Add Test Runner and Documentation

**Files:**
- Create: `tests/run-tests.sh`
- Modify: `tests/README.md`

**Step 1: Create test runner script**

Create `tests/run-tests.sh`:

```bash
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
```

Make it executable:

```bash
chmod +x tests/run-tests.sh
```

**Step 2: Update README with more details**

Update `tests/README.md` to add:

```markdown

## Test Coverage

### test_common.bats
- Distribution detection (Debian, Ubuntu, Arch)
- Helper functions (is_debian_based, is_arch_based)
- Package installation detection for apt and pacman

### test_debian_bootstrap.bats
- Debian/Ubuntu bootstrap entry point
- APT package management
- GUI vs headless detection
- Repository setup

### test_arch_bootstrap.bats
- Arch Linux bootstrap entry point
- Pacman package management
- AUR package support via yay
- GUI vs headless detection

### test_main_bootstrap.bats
- Main bootstrap dispatcher
- Platform detection
- Command-line argument parsing
- Dry-run mode

## Continuous Testing

Run tests automatically with:

```bash
./tests/run-tests.sh
```

## Test Philosophy

We follow TDD:
1. Write failing test
2. Implement minimal code to pass
3. Refactor while keeping tests green
4. Commit frequently
```

**Step 3: Run all tests to verify everything works**

```bash
./tests/run-tests.sh
```

Expected: All tests pass with summary.

**Step 4: Commit**

```bash
git add tests/run-tests.sh tests/README.md
git commit -m "test: add test runner script and update documentation

- Add run-tests.sh for easy test execution
- Update README with test coverage details
- Document TDD philosophy and continuous testing"
```

---

## Task 7: Add Pre-commit Hook for Tests

**Files:**
- Create: `.git_hooks/pre-commit-tests` (or modify existing)
- Modify: `.git_hooks/pre-commit` (if exists)

**Step 1: Check if git hooks exist**

```bash
ls -la .git_hooks/
```

**Step 2: Create test hook**

Create `.git_hooks/pre-commit-tests`:

```bash
#!/usr/bin/env bash
# ABOUTME: Pre-commit hook to run bootstrap tests
# ABOUTME: Ensures tests pass before committing changes to bootstrap scripts

set -euo pipefail

# Only run if bootstrap files changed
if git diff --cached --name-only | grep -qE "\.config/yadm/bootstrap"; then
    echo "Bootstrap files changed, running tests..."

    if ! ./tests/run-tests.sh; then
        echo "Tests failed. Fix tests before committing."
        exit 1
    fi
fi

exit 0
```

Make it executable:

```bash
chmod +x .git_hooks/pre-commit-tests
```

**Step 3: Integrate with existing pre-commit if it exists**

If `.git_hooks/pre-commit` exists, add this line before the final exit:

```bash
# Run bootstrap tests
./.git_hooks/pre-commit-tests
```

If it doesn't exist, create it:

```bash
#!/usr/bin/env bash
# ABOUTME: Main pre-commit hook that runs all pre-commit checks
# ABOUTME: Calls individual hook scripts for modular testing

set -euo pipefail

# Run bootstrap tests
./.git_hooks/pre-commit-tests

exit 0
```

Make it executable:

```bash
chmod +x .git_hooks/pre-commit
```

**Step 4: Test the hook**

Make a trivial change to a bootstrap file and try to commit:

```bash
echo "# test" >> .config/yadm/bootstrap.d/common.sh
git add .config/yadm/bootstrap.d/common.sh
git commit -m "test: verify pre-commit hook runs"
```

Should run tests before committing.

Reset the test change:

```bash
git reset HEAD~1
git checkout .config/yadm/bootstrap.d/common.sh
```

**Step 5: Commit the hooks**

```bash
git add .git_hooks/pre-commit-tests .git_hooks/pre-commit
git commit -m "chore: add pre-commit hook for bootstrap tests

- Run tests automatically when bootstrap files change
- Prevent commits if tests fail
- Integrate with existing git hooks structure"
```

---

## Verification

After completing all tasks, verify the implementation:

### 1. Run all tests

```bash
./tests/run-tests.sh
```

Expected: All tests pass.

### 2. Test dry-run for Debian

```bash
./.config/yadm/bootstrap --dry-run --platform linux
```

Expected: Shows Debian bootstrap in dry-run mode.

### 3. Test dry-run for Darwin

```bash
./.config/yadm/bootstrap --dry-run --platform darwin
```

Expected: Shows Darwin bootstrap in dry-run mode.

### 4. Verify help works

```bash
./.config/yadm/bootstrap --help
```

Expected: Shows usage information.

### 5. Check test coverage

```bash
bats --count tests/
```

Expected: Shows total number of tests (should be 15+).

---

## Success Criteria

- ✅ All tests pass
- ✅ Arch Linux support implemented with pacman and AUR
- ✅ Debian/Ubuntu support refactored and tested
- ✅ Distribution detection works for Debian, Ubuntu, and Arch
- ✅ Pre-commit hooks run tests automatically
- ✅ Dry-run mode works for all platforms
- ✅ Documentation updated
- ✅ Test coverage includes unit and integration tests

## Future Enhancements

Consider adding:
- Support for Fedora/RHEL (dnf/yum)
- Support for openSUSE (zypper)
- More granular GUI detection tests
- Mock-based testing for actual package installation
- CI/CD integration for automated testing
