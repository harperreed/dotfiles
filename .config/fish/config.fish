# Fish shell main configuration

# Load theme settings
source ~/.config/fish/theme.fish

# Load secrets
for i in (cat ~/.secrets/secrets.env)
    if test (echo $i | sed -E 's/^[[:space:]]*(.).+$/\\1/g') != "#"
        set arr (echo $i |tr = \n)
        set -gx $arr[1] $arr[2]
    end
end

# Custom greeting
function fish_greeting
    set -l hostname_cmd (command -v hostname)
    set -l figlet_cmd (command -v figlet)
    set -l lolcat_cmd (command -v lolcat)

    if test -n "$hostname_cmd" -a -n "$figlet_cmd" -a -n "$lolcat_cmd"
        # Use command to bypass any GRC wrappers
        command $hostname_cmd -s | command $figlet_cmd -w 100 -f ~/.config/fonts/Bloody.flf | $lolcat_cmd
        command fortune | $lolcat_cmd
    else
        echo "Welcome!"
    end
    echo
    echo
end


function add_ssh_keys --on-variable SSH_AUTH_SOCK
    ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
end

# Start ssh-agent if it's not already running
if not test -n "$SSH_AUTH_SOCK"
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Source aliases and paths
source ~/.config/fish/aliases.fish
source ~/.config/fish/paths.fish

# Platform-specific configurations
switch (uname)
    case Linux
        echo Hi Tux!
    case Darwin
        set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
        set -gx PUPPETEER_EXECUTABLE_PATH (which chromium)
        add_ssh_keys
    case FreeBSD NetBSD DragonFly
        echo Hi Beastie!
    case '*'
        echo Hi, stranger!
end

# iTerm2 integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# Conda initialization
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
else if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    source "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
else
    set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
end

# Go configuration
switch (uname -m)
    case 'x86_64'
        set GOPATH /home/harper/go/
    case 'arm64'
        set GOPATH /Users/harper/workspace/personal/go
end

# Atuin shell history
if status is-interactive
    atuin init fish | source
end

# ASDF version manager
# source /opt/homebrew/opt/asdf/libexec/asdf.fish

# SSH agent configuration
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Function to add SSH keys on demand
function add_ssh_keys
    ssh-add --apple-use-keychain ~/.ssh/id_rsa
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    # Add more keys as needed
end

# Load custom functions
for f in ~/.config/fish/functions/*.fish
    source $f
end



# Set default editors
set -gx EDITOR nvim
set -gx VISUAL nvim

# Set language and locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Set PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/local/sbin $PATH

# Python settings
set -gx PYTHONDONTWRITEBYTECODE 1

# Java settings
set -gx JAVA_HOME (/usr/libexec/java_home)

# Node.js settings
set -gx NODE_ENV development

# Go settings
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH


# Rust settings
set -gx PATH $HOME/.cargo/bin $PATH

#mise settings
/opt/homebrew/bin/mise activate fish | source
