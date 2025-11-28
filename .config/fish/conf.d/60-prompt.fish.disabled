# ABOUTME: Custom enhanced prompt with git status, command duration, and vi mode
# ABOUTME: Smart display of user@host (SSH only), Python venv, and execution feedback

# Turn off the prompt for virtualenv (we handle it ourselves)
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Helper function for git status indicators with better performance
function __fish_git_status_chars
    # Bail early if not in git repo
    command -q git; or return
    git rev-parse --git-dir >/dev/null 2>&1; or return
    
    set -l git_status (git status --porcelain 2>/dev/null)
    test -z "$git_status"; and return
    
    set -l indicators ""
    set -l modified 0
    set -l staged 0
    set -l untracked 0
    set -l deleted 0
    
    # Parse git status more efficiently
    for line in (echo "$git_status")
        set -l status_code (string sub -l 2 -- "$line")
        switch "$status_code"
            case 'M ' ' M' 'MM'
                set modified 1
            case 'A ' 'AM'
                set staged 1
            case '??'
                set untracked 1
            case 'D ' ' D'
                set deleted 1
        end
    end
    
    # Build indicators
    test $modified -eq 1 && set indicators "$indicators±"    # Modified
    test $staged -eq 1 && set indicators "$indicators+"      # Staged  
    test $untracked -eq 1 && set indicators "$indicators?"    # Untracked
    test $deleted -eq 1 && set indicators "$indicators×"      # Deleted
    
    test -n "$indicators" && echo " [$indicators]"
end

# Helper to get git branch with detached HEAD handling
function __fish_git_branch
    set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        # Detached HEAD - show short SHA
        set branch (git rev-parse --short HEAD 2>/dev/null)
        test -n "$branch" && echo "detached:$branch"
    else
        echo $branch
    end
end

# Helper to check if we're ahead/behind upstream
function __fish_git_upstream_status
    set -l upstream (git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    test -z "$upstream"; and return
    
    set -l ahead (git rev-list --count @{u}..HEAD 2>/dev/null)
    set -l behind (git rev-list --count HEAD..@{u} 2>/dev/null)
    
    set -l upstream_status ""
    test "$ahead" -gt 0 && set upstream_status "$upstream_status↑$ahead"
    test "$behind" -gt 0 && set upstream_status "$upstream_status↓$behind"
    
    test -n "$upstream_status" && echo " $upstream_status"
end

# Helper for command duration
function __fish_cmd_duration
    test -z "$CMD_DURATION"; and return
    test "$CMD_DURATION" -lt 5000; and return  # Only show if >5s
    
    set -l duration (math -s0 "$CMD_DURATION / 1000")
    set -l minutes (math -s0 "$duration / 60")
    set -l seconds (math -s0 "$duration % 60")
    
    set_color yellow
    if test $minutes -gt 0
        echo -n " "$minutes"m"$seconds"s"
    else
        echo -n " "$seconds"s"
    end
    set_color normal
end

# Vi mode indicator disabled - we don't need it
function fish_mode_prompt
    # Intentionally empty to suppress vi mode display
end

function fish_prompt
    set -l last_status $status
    
    # Print a newline before the prompt
    echo
    
    # Print Python virtual environment if active (shortened)
    if set -q VIRTUAL_ENV
        set_color --bold blue
        echo -n "("(basename "$VIRTUAL_ENV")") "
        set_color normal
        echo
    end
    
    # Print username@hostname only in SSH sessions
    if set -q SSH_CLIENT; or set -q SSH_TTY
        set_color brblue
        echo -n (whoami)
        set_color normal
        echo -n "@"
        set_color yellow
        echo -n (hostname -s)
        set_color normal
        echo
    end
    
    # Print current working directory (expanded)
    set_color $fish_color_cwd
    set -l cwd (pwd | string replace -r "^$HOME" "~")
    # Show last 4 path components, or full path if shorter
    set -l path_parts (string split "/" $cwd)
    if test (count $path_parts) -gt 4
        echo "…/"(string join "/" $path_parts[-4..-1])
    else
        echo $cwd
    end
    set_color normal
    
    # Print Git information if in a Git repository
    if command -q git; and git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set_color normal
        echo -n "on "
        set_color magenta
        echo -n (__fish_git_branch)
        set_color yellow
        echo -n (__fish_git_status_chars)
        set_color cyan
        echo -n (__fish_git_upstream_status)
        set_color normal
        
        # Show stash count if any
        set -l stash_count (git stash list 2>/dev/null | wc -l | string trim)
        if test "$stash_count" -gt 0
            set_color blue
            echo -n " {$stash_count}"
            set_color normal
        end
        echo
    end
    
    # Print command duration if last command took >5s
    set -l duration_str (__fish_cmd_duration)
    if test -n "$duration_str"
        echo -n "took"
        echo $duration_str
    end
    
    # Print prompt symbol with exit status color
    if test $last_status -eq 0
        set_color green
    else
        set_color red
        echo -n "[$last_status] "
    end
    echo -n '➜ '
    set_color normal
end