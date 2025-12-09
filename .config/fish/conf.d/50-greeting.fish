# ABOUTME: Custom greeting function for fish shell
# ABOUTME: Displays hostname with figlet and fortune on startup

# Custom greeting
function fish_greeting
    # Minimal greeting in tmux
    if set -q TMUX
        command fortune | lolcat
        return
    end

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