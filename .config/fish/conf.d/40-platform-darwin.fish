# ABOUTME: Platform-specific configuration for macOS/Darwin
# ABOUTME: Includes iTerm2, Homebrew, Conda, Go, and other macOS tools

# Only run on macOS
if test (uname) != "Darwin"
    exit
end


# Go environment
set -gx GOPATH $HOME/workspace/personal/go
fish_add_path -g $GOPATH/bin

# Puppeteer settings
set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
set -gx PUPPETEER_EXECUTABLE_PATH (which chromium)

# iTerm2 integration (disabled - was conflicting with custom prompt)
# if test -e {$HOME}/.iterm2_shell_integration.fish
#     source {$HOME}/.iterm2_shell_integration.fish
# end

# Conda lazy initialization
# Set up conda paths but defer full initialization until first use
set -gx CONDA_PREFIX /opt/homebrew/Caskroom/miniconda/base
if test -d $CONDA_PREFIX/bin
    fish_add_path -g $CONDA_PREFIX/bin
end

# Create a wrapper function that initializes conda on first use
function conda --description 'Lazy-loaded conda' --wraps conda
    # Initialize conda properly
    eval $CONDA_PREFIX/bin/conda "shell.fish" "hook" | source
    # Call conda with the original arguments
    conda $argv
end

# mise settings
if test -e /opt/homebrew/bin/mise
    /opt/homebrew/bin/mise activate fish | source
end