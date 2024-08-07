# Fish shell PATH configurations

set -gx PATH $HOME/.npm-global/bin $PATH
set -gx PATH $HOME/.config/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/local/sbin $PATH

# Go settings
set -gx PATH $GOPATH/bin $PATH

# Add more PATH configurations here if needed
# Rust settings
set -gx PATH $HOME/.cargo/bin $PATH
