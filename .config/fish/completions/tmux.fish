# ABOUTME: Override fish's built-in tmux completions to prevent freezing
# ABOUTME: The default completions run `tmux list-commands` which blocks

# Just provide basic static completions - no dynamic stuff
complete -c tmux -x

# Main subcommands (static, no blocking calls)
complete -c tmux -n __fish_use_subcommand -a attach -d 'Attach to session'
complete -c tmux -n __fish_use_subcommand -a detach -d 'Detach client'
complete -c tmux -n __fish_use_subcommand -a has -d 'Check if session exists'
complete -c tmux -n __fish_use_subcommand -a kill-server -d 'Kill tmux server'
complete -c tmux -n __fish_use_subcommand -a kill-session -d 'Kill session'
complete -c tmux -n __fish_use_subcommand -a kill-window -d 'Kill window'
complete -c tmux -n __fish_use_subcommand -a list-clients -d 'List clients'
complete -c tmux -n __fish_use_subcommand -a list-commands -d 'List commands'
complete -c tmux -n __fish_use_subcommand -a list-sessions -d 'List sessions'
complete -c tmux -n __fish_use_subcommand -a list-windows -d 'List windows'
complete -c tmux -n __fish_use_subcommand -a new -d 'New session'
complete -c tmux -n __fish_use_subcommand -a new-session -d 'New session'
complete -c tmux -n __fish_use_subcommand -a new-window -d 'New window'
complete -c tmux -n __fish_use_subcommand -a rename -d 'Rename session'
complete -c tmux -n __fish_use_subcommand -a rename-session -d 'Rename session'
complete -c tmux -n __fish_use_subcommand -a rename-window -d 'Rename window'
complete -c tmux -n __fish_use_subcommand -a select-pane -d 'Select pane'
complete -c tmux -n __fish_use_subcommand -a select-window -d 'Select window'
complete -c tmux -n __fish_use_subcommand -a send-keys -d 'Send keys'
complete -c tmux -n __fish_use_subcommand -a set -d 'Set option'
complete -c tmux -n __fish_use_subcommand -a show -d 'Show options'
complete -c tmux -n __fish_use_subcommand -a source -d 'Source config'
complete -c tmux -n __fish_use_subcommand -a split-window -d 'Split window'
complete -c tmux -n __fish_use_subcommand -a swap-pane -d 'Swap panes'
complete -c tmux -n __fish_use_subcommand -a swap-window -d 'Swap windows'
complete -c tmux -n __fish_use_subcommand -a switch-client -d 'Switch client'

# Short aliases
complete -c tmux -n __fish_use_subcommand -a a -d 'Attach (alias)'
complete -c tmux -n __fish_use_subcommand -a ls -d 'List sessions (alias)'
complete -c tmux -n __fish_use_subcommand -a lsc -d 'List clients (alias)'
complete -c tmux -n __fish_use_subcommand -a lsw -d 'List windows (alias)'

# Front flags
complete -c tmux -n __fish_use_subcommand -s 2 -d '256 colours'
complete -c tmux -n __fish_use_subcommand -s l -d 'Login shell'
complete -c tmux -n __fish_use_subcommand -s u -d 'UTF-8'
complete -c tmux -n __fish_use_subcommand -s v -d 'Verbose'
complete -c tmux -n __fish_use_subcommand -s V -d 'Version'
complete -c tmux -n __fish_use_subcommand -s f -r -d 'Config file'
complete -c tmux -n __fish_use_subcommand -s L -x -d 'Socket name'
complete -c tmux -n __fish_use_subcommand -s S -r -d 'Socket path'
