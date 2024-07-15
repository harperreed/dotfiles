# Git-related functions

function git_current_branch
    set -l ref (git symbolic-ref HEAD 2> /dev/null); or \
    set -l ref (git rev-parse --short HEAD 2> /dev/null); or return
    echo $ref | sed -e 's|^refs/heads/||'
end

function git_current_repository
    set -l ref (git symbolic-ref HEAD 2> /dev/null); or \
    set -l ref (git rev-parse --short HEAD 2> /dev/null); or return
    echo (git remote -v | cut -d':' -f 2)
end

# Add more Git-related functions here
