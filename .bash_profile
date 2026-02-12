# ABOUTME: Login shell config for bash - sources .bashrc and runs login-only stuff
# ABOUTME: Keep this thin - all interactive config goes in .bashrc

# Source .bashrc for all interactive config
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Login shell banner (only runs once per login, not every subshell)
if [ -n "$PS1" ]; then
    hostname | figlet -f ~/.config/fonts/Bloody.flf | lolcat 2>/dev/null
    fortune | lolcat 2>/dev/null
fi
