### mosh/tmux helpers ###

# w: mosh into host, attach/create tmux session
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

    mosh $host -- tmux new-session -A -s $session
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
