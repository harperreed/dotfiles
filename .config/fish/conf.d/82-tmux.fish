### mosh/tmux helpers ###

# w: mosh into host, attach/create tmux session
# usage:
#   m host           -> session "main"
#   m host foo       -> session "foo"
#   m host 3         -> session "3"
function m --description "mosh into host and attach tmux session"
    if test (count $argv) -lt 1
        echo "usage: m <host> [session]"
        return 1
    end

    set host $argv[1]
    set session "main"

    if test (count $argv) -ge 2
        set session $argv[2]
    end

    mosh $host -- tmux new-session -A -s $session
end


# ws: plain ssh into host (with agent forwarding etc)
# usage:
#   ms host          -> ssh host
#   ms host cmd ...  -> ssh host 'cmd ...'
function ms --description "ssh into host (optionally run command)"
    if test (count $argv) -lt 1
        echo "usage: ms <host> [command ...]"
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
