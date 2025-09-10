# ABOUTME: Navigation and utility helpers for common tasks
# ABOUTME: Productivity functions for directory ops, process management, and PATH viewing

# mkdir -p + cd
function mkcd; mkdir -p $argv[1]; and cd $argv[1]; end

# cd to repo root
function cdr
  set -l root (git rev-parse --show-toplevel ^/dev/null 2>/dev/null)
  test -n "$root"; and cd "$root"
end

# Kill a process by fuzzy pick
function fkill
  set -l pid (ps -A -o pid,command | fzf --header='kill process' --preview 'ps -p {1} -o pid,ppid,user,%cpu,%mem,etime,command' | awk '{print $1}')
  test -n "$pid"; and kill -9 $pid
end

# Free a port fast: killport 3000
function killport
  test -z "$argv[1]"; and echo "usage: killport <port>" && return 1
  set -l pid (lsof -iTCP:$argv[1] -sTCP:LISTEN -Pn -t 2>/dev/null)
  test -n "$pid"; and kill -9 $pid; and echo "killed $pid"
end

# PATH viewer
function path
  printf '%s\n' $PATH | nl -ba
end