### mosh/tmux helpers ###

# w: mosh into host, attach/create tmux session with auto-retry
# usage:
#   w host           -> session "main"
#   w host foo       -> session "foo"
#   w host 3         -> session "3"
function w --description "mosh into host and attach tmux session"
    if test (count $argv) -lt 1
        echo "usage: w <host> [session]"
        return 1
    end

    set host $argv[1]
    set session "main"

    if test (count $argv) -ge 2
        set session $argv[2]
    end

    # Save last host for quick reconnect
    set -Ux BLINK_LAST_HOST $host
    set -Ux BLINK_LAST_SESSION $session

    echo "🚀 Connecting to $host (session: $session)..."

    # Try mosh with retry logic
    set retry_count 0
    set max_retries 3

    while test $retry_count -lt $max_retries
        if mosh $host -- tmux new-session -A -s $session
            return 0
        else
            set retry_count (math $retry_count + 1)
            if test $retry_count -lt $max_retries
                echo "⚠️  Connection failed, retrying ($retry_count/$max_retries)..."
                sleep 2
            else
                echo "❌ Failed to connect after $max_retries attempts"
                echo "💡 Try: ssh $host (or check if mosh is installed on remote)"
                return 1
            end
        end
    end
end

# wr: reconnect to last mosh session
function wr --description "reconnect to last mosh host and session"
    if not set -q BLINK_LAST_HOST
        echo "❌ No previous host stored. Use 'w hostname' first."
        return 1
    end

    echo "🔄 Reconnecting to $BLINK_LAST_HOST..."
    w $BLINK_LAST_HOST $BLINK_LAST_SESSION
end

# ws: plain ssh into host (with agent forwarding etc)
# usage:
#   ws host          -> ssh host
#   ws host cmd ...  -> ssh host 'cmd ...'
function ws --description "ssh into host (optionally run command)"
    if test (count $argv) -lt 1
        echo "usage: ws <host> [command ...]"
        return 1
    end

    set host $argv[1]
    set cmd  $argv[2..-1]

    if test (count $cmd) -eq 0
        ssh $host
    else
        ssh $host $cmd
    end
end

# wl: list common hosts from SSH config
function wl --description "list configured SSH hosts"
    echo "📋 Configured hosts:"
    grep -E "^Host " ~/.ssh/config | grep -v "\*" | awk '{print "  •", $2}'
end

# wq: quick connect menu using fzf
function wq --description "quick host selector with fzf"
    if not command -q fzf
        echo "❌ fzf not installed"
        return 1
    end

    set host (grep -E "^Host " ~/.ssh/config | grep -v "\*" | awk '{print $2}' | fzf --prompt="Select host: ")

    if test -n "$host"
        w $host
    end
end
