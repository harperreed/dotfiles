
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
end


function add_ssh_keys_darwin --on-variable SSH_AUTH_SOCK
    set -l lolcat_cmd (command -v lolcat)
    if test -n "$SSH_TTY"
        # We are connected via SSH
        echo
        echo "🔒 Connected via SSH. Using SSH agent forwarding." | $lolcat_cmd
        echo
    else if test -n "$SSH_CONNECTION"
        # We are connected via SSH but without a TTY (e.g., in a script)
        # echo
        # echo "🤖 Connected via SSH (non-interactive). Using SSH agent forwarding." | $lolcat_cmd
        # echo
    else
        # We are on a physical terminal
        echo
        echo "💻 On physical terminal. Adding local SSH keys." | $lolcat_cmd
        echo
        ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
    end
end

# Start ssh-agent if it's not already running
if not test -n "$SSH_AUTH_SOCK"
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end




function init_darwin

    # iTerm2 integration
    if test -e {$HOME}/.iterm2_shell_integration.fish
        source {$HOME}/.iterm2_shell_integration.fish
    end

    # Conda initialization
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
        eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
            . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        else
            set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
        end
    end
    # <<< conda initialize <<<

    # Set up Go environment
    set -gx GOPATH $HOME/workspace/personal/go

    #mise settings
    /opt/homebrew/bin/mise activate fish | source

    # Set up Puppeteer
    set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
    set -gx PUPPETEER_EXECUTABLE_PATH (which chromium)

    # ASDF version manager
    # source /opt/homebrew/opt/asdf/libexec/asdf.fish

    # Add SSH keys
    add_ssh_keys_darwin


end

# Platform-specific configurations
switch (uname)
    case Linux
        echo "                .88888888:."
        echo "               88888888.88888."
        echo "             .8888888888888888."
        echo "             888888888888888888"
        echo "             88' _`88'_  `88888"
        echo "             88 88 88 88  88888"
        echo "             88_88_::_88_:88888"
        echo "             88:::,::,:::::8888"
        echo "             88`:::::::::'`8888"
        echo "            .88  `::::'    8:88."
        echo "           8888            `8:888."
        echo "         .8888'             `888888."
        echo "        .8888:..  .::.  ...:'8888888:."
        echo "       .8888.'     :'     `'::`88:88888"
        echo "      .8888        '         `.888:8888."
        echo "     888:8         .           888:88888"
        echo "   .888:88        .:           888:88888:"
        echo "   8888888.       ::           88:888888"
        echo "   `.::.888.      ::          .88888888"
        echo "  .::::::.888.    ::         :::`8888'.:."
        echo " ::::::::::.888   '         .::::::::::::"
        echo " ::::::::::::.8    '      .:8::::::::::::."
        echo ".::::::::::::::.        .:888:::::::::::::"
        echo ":::::::::::::::88:.__..:88888:::::::::::'"
        echo " `'.:::::::::::88888888888.88:::::::::'"
        echo "       `':::_:' -- '' -'-' `':_::::'`"


        set -gx GOPATH $HOME/go
        ~/.local/bin/mise activate fish | source
        if status is-interactive
          echo "Hi Tux!"
        end 
    case Darwin

        init_darwin

    case FreeBSD NetBSD DragonFly
        echo Hi Beastie!
    case '*'
        echo Hi, stranger!
end



# Atuin shell history
if status is-interactive
    atuin init fish | source
end


# SSH agent configuration
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
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

# Python settings
set -gx PYTHONDONTWRITEBYTECODE 1

# Java settings
if test -e /usr/libexec/java_home
   set -gx JAVA_HOME (/usr/libexec/java_home)
end 

# Node.js settings
set -gx NODE_ENV development
set -x OSTYPE (uname | tr '[:upper:]' '[:lower:]')

# Source aliases and paths
source ~/.config/fish/aliases.fish
source ~/.config/fish/paths.fish
