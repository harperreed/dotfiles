#!/usr/bin/env bats

load setup

@test "detect_linux_distro detects debian" {
    load_common

    # Mock /etc/os-release for Debian
    export MOCK_OS_RELEASE="ID=debian"

    # Override file reading
    detect_linux_distro() {
        echo "$MOCK_OS_RELEASE" | grep "^ID=" | cut -d= -f2 | tr -d '"'
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
