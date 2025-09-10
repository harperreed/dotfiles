# Theme Options
# These options customize the appearance of your shell prompt and other UI elements

# Git integration
set -g theme_display_git yes                   # Show Git information in prompt
set -g theme_display_git_dirty no              # Don't show 'dirty' indicator for Git repos
set -g theme_display_git_untracked no          # Don't show indicator for untracked files
set -g theme_display_git_ahead_verbose yes     # Show detailed ahead/behind counts for Git repos
set -g theme_display_git_dirty_verbose yes     # Show detailed dirty indicator for Git repos
set -g theme_display_git_master_branch yes     # Show 'master' branch name instead of detached HEAD
set -g theme_git_worktree_support yes          # Enable Git worktree support

# Other version control systems
set -g theme_display_vagrant no                # Don't show Vagrant status in prompt
set -g theme_display_docker_machine no         # Don't show Docker machine status
set -g theme_display_k8s_context yes           # Show Kubernetes context
set -g theme_display_hg yes                    # Show Mercurial information in prompt

# Environment indicators
set -g theme_display_virtualenv yes            # Show active Python virtual environment
set -g theme_display_ruby no                   # Don't show Ruby version

# User and host display
set -g theme_display_user ssh                  # Show user in SSH sessions
set -g theme_display_hostname ssh              # Show hostname in SSH sessions

# Additional UI elements
set -g theme_display_vi no                     # Don't show Vi mode indicator
set -g theme_display_date yes                  # Show current date in prompt
set -g theme_display_cmd_duration yes          # Show duration of last command
set -g theme_title_display_process yes         # Show current process in terminal title
set -g theme_title_display_path yes            # Show current path in terminal title
set -g theme_title_display_user yes            # Show username in terminal title
set -g theme_title_use_abbreviated_path yes    # Use abbreviated path in terminal title

# Prompt appearance
set -g theme_date_format "+%a %H:%M"           # Date format for prompt
set -g theme_avoid_ambiguous_glyphs yes        # Avoid ambiguous Unicode glyphs
set -g theme_powerline_fonts yes               # Use Powerline fonts if available
set -g theme_nerd_fonts no                     # Don't use Nerd Fonts
set -g theme_show_exit_status yes              # Show exit status of last command
set -g theme_color_scheme terminal2-dark-black # Color scheme for the prompt
set -g fish_prompt_pwd_dir_length 20           # Shorten directory names in prompt
set -g theme_project_dir_length 1              # Shorten project directory names
set -g theme_newline_cursor yes                # Put cursor on a new line

# Default user (won't be shown in prompt)
set -g default_user your_normal_user

# Turn off the prompt for virtualenv
set -x VIRTUAL_ENV_DISABLE_PROMPT 1


function fish_prompt
    set -l last_status $status

    # Print a newline before the prompt
    echo

    # Print Python virtual environment if active
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue black) "[" (basename "$VIRTUAL_ENV") " 🐍]" (set_color normal) " "
    end

    # Print username and hostname
    set_color brblue
    echo -n (whoami)
    set_color normal
    echo -n "@"
    set_color yellow
    echo -n (hostname -s)
    set_color normal
    echo -n ":"

    # Print current working directory
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    # Print Git information if in a Git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set_color normal
        echo -n " on "
        set_color magenta
        echo -n (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set_color green
        echo -n (fish_git_prompt)
    end


    # Print prompt symbol
    echo
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n '➜ '
    set_color normal
end
