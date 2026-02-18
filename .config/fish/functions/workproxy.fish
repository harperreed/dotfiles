# ABOUTME: Fish function to create SSH tunnels to dev server (disaster) for multiple ports.
# ABOUTME: Usage: workproxy 2389 3000 8080 13371
function workproxy --description "SSH tunnel multiple ports to disaster"
    if test (count $argv) -eq 0
        set_color red
        echo "  Usage: workproxy PORT [PORT ...]"
        set_color normal
        return 1
    end

    # Validate all args are numeric ports
    for port in $argv
        if not string match -qr '^\d+$' $port; or test $port -lt 1; or test $port -gt 65535
            set_color red
            printf "  Invalid port: %s (must be 1-65535)\n" $port
            set_color normal
            return 1
        end
    end

    set -l tunnel_args
    for port in $argv
        set -a tunnel_args -L $port:127.0.0.1:$port
    end

    # inner box width = 38
    echo
    set_color brblack
    echo "  ╭──────────────────────────────────────╮"
    echo "  │        workproxy → disaster          │"
    echo "  ├──────────────────────────────────────┤"
    set_color normal
    for port in $argv
        set -l portlen (string length $port)
        set -l pad (math "38 - 24 - 2 * $portlen")

        set_color brblack
        printf "  │  "
        set_color green
        printf "localhost:%s" $port
        set_color brblack
        printf " → "
        set_color cyan
        printf "disaster:%s" $port
        set_color brblack
        printf "%*s│\n" $pad ""
    end
    set_color brblack
    echo "  ╰──────────────────────────────────────╯"
    set_color normal
    echo
    set_color brblack
    echo "  ctrl+c to disconnect"
    set_color normal
    echo

    ssh -N $tunnel_args harper@disaster
    set -l ssh_status $status
    if test $ssh_status -ne 0
        echo
        set_color red
        printf "  ssh exited with status %d\n" $ssh_status
        set_color normal
    end
    return $ssh_status
end
