# ABOUTME: Git-related utility functions for fish shell
# ABOUTME: Provides helper functions for working with git repositories

function git_current_branch --description 'Get the current git branch name'
    command git symbolic-ref --short HEAD 2>/dev/null
    or command git rev-parse --short HEAD 2>/dev/null
end

function git_current_repository --description 'Get the current git repository name'
    # Get the origin URL and extract the repository name
    set -l url (command git config --get remote.origin.url 2>/dev/null)
    if test -n "$url"
        # Extract repository name from URL (works with both HTTPS and SSH)
        echo $url | sed -E 's|^.*/([^/]+)(\.git)?$|\1|'
    end
end

# Add more Git-related functions here
