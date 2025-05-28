# ABOUTME: Platform-specific configuration for Linux
# ABOUTME: Includes Linux-specific tools and environment setup

# Only run on Linux
if test (uname) != "Linux"
    exit
end

# Go environment
set -gx GOPATH $HOME/go
fish_add_path -g $GOPATH/bin

# mise settings
if test -e ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

# Linux welcome message
if status is-interactive
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
    echo
    echo "Hi Tux!"
end