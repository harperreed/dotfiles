#!/usr/bin/fish

# WARP DIRECTORY
# ==============
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# This script is heavily influenced by :
# @github.com/mfaerevaag/wd 
#
# And it is decined to be compatible with the original wd.
#
# author
# @github.com/fischerling

function __wd_print_msg -d "prints a message with the color given in argv[1]"
    if set -q quiet
        return
    end
    set_color $argv[1]
    echo $argv[2]
    set_color "normal"
end

function __wd_exit_fail
    __wd_print_msg "red" $argv[1]
    set __wd_exit_status 1
end

function __wd_exit_nopoint
    __wd_print_msg "red" "Warp point $argv[1] not found"
    set __wd_exit_status 1
end

function __wd_exit_warn
    __wd_print_msg "yellow" $argv[1]
    set __wd_exit_status 1
end

function __wd_read_warprc
    cat $__wd_warprc
end

function __wd_help --argument command
    echo
    switch $command
        case ""
            echo "..              Pop the last directory from the directory stack"
            echo "add <point>     Adds the current working directory to your warp points"
            echo "add! <point>    Overwrites existing warp point"
            echo "rm <point>      Removes the given warp point"
            echo "show            Print warp points to current directory"
            echo "show <point>    Print path to given warp point"
            echo "list            Print all stored warp points"
            echo "warppoints      Print names of all stored warp points"
            echo "warppoints-file Print path where the warppoints are stored"
            echo "ls <point>      Show files from given warp point"
            echo "path <point>    Show the path to given warp point"
            echo "clean           Remove warp points to nonexistent directories"
            echo "clean!          Same as clean without confirmation"
            echo
            echo "-v | --version  Print version"
            echo "-c | --config   Specify and set config file (default ~/.warprc)"
            echo "-q | --quiet    Suppress all output"
            echo "-f | --force    Equivalent to '!' with add and clean"
            echo
            echo "help [command]  Shows help about specific command"

        case ".."
            echo "Pops the last directory from the directory stack"
            echo
            echo "Usage:"
            echo "      wd .."

        case "add"
            echo "Adds the current working directory to your warp points"
            echo
            echo "Usage:"
            echo "      wd add <point_name>"

        case "add!"
            echo "Overwrites existing warp point"
            echo
            echo "Usage:"
            echo "      wd add! <point_name>"

        case "rm"
            echo "Removes the given warp point"
            echo
            echo "Usage:"
            echo "      wd rm <point_name>"

        case "show"
            echo "1) Print warp points to current directory or"
            echo "2) Print path to given warp point"
            echo
            echo "Usage:"
            echo "1)      wd show"
            echo "2)      wd show <point_name>"


        case "list"
            echo "Print all stored warp points"
            echo
            echo "Usage:"
            echo "      wd list"

        case "warppoints"
            echo "Print names of all stored warp points"
            echo
            echo "Usage:"
            echo "      wd warppoints"

        case "warppoints-file"
            echo "Print path where the warppoints are stored"
            echo
            echo "Usage:"
            echo "      wd warppoints-file"

        case "ls"
            echo "Show files from given warp point"
            echo
            echo "Usage:"
            echo "      wd ls <point_name>"


        case "path"
            echo "Show the path to given warp point"
            echo
            echo "Usage:"
            echo "      wd path <point_name> "


        case "clean"
            echo "Remove warp points to nonexistent directories"
            echo
            echo "Usage:"
            echo "      wd clean" 


        case "clean!"
            echo "Same as clean without confirmation"
            echo
            echo "Usage:"
            echo "      wd clean!"

        case "-v" "--version"
            echo "Print version"
            echo
            echo "Usage:"
            echo "      wd -v [option] [command]"
            echo "      wd --version [option] [command]"
            echo "Output:"
            echo "      wd version <wd_version>"
            echo "      [output from command]"


        case "-c" "--config"
            echo "Specify and set config file (default ~/.warprc)"
            echo
            echo "Usage:"
            echo "      wd -c <path/to/config> [options] [command]"
            echo "      wd --config <path/to/config> [options] [command]"


        case "-q" "--quiet"
            echo "Suppress all output"
            echo
            echo "Usage:"
            echo "      wd -q [options] [command]"
            echo "      wd --quiet [options] [command]"


        case "-f" "--force"
            echo "Equivalent to '!' with add and clean"
            echo
            echo "Usage:"
            echo "      wd -f add <point> == wd add! <point>"
            echo "      wd -f clean == wd clean!"


        case "*"
            echo "no help available for $command"
            echo "please use wd help for an overview of all commands"
    end
end

function __wd_add
    if string match -r "^(\.)+\$" $argv[2] >/dev/null
        __wd_exit_fail "Warp point cannot be just dots"
    else if string match "*/*" $argv[2] >/dev/null
        __wd_exit_fail "Warp point cannot contain '/'"
    else if string match "* *" $argv[2] >/dev/null
        __wd_exit_fail "Warp point cannot contain whitespace"
    else if string match "*:*" $argv[2] >/dev/null
        __wd_exit_fail "Warp point cannot contain colons"
    else if test -z "$argv[2]"
        __wd_exit_fail "Warp point cannot be empty"
    else
        set path (__wd_path $argv[2])
        if test -n "$path"
            if test "$argv[1]" = "true"
                __wd_remove $argv[2] >/dev/null
            else
                __wd_exit_fail "Warp point $argv[2] already exists. Use add! or -f to overwrite."
                return
            end
        end
        echo "$argv[2]:$PWD" >> $__wd_warprc
        __wd_print_msg "green" "Warp point $argv[2] added"
    end
end

function __wd_clean
    for l in (__wd_read_warprc)
        if not test -d (string split ":" $l)[2]
            set broken_entries $broken_entries $l
            echo -n (__wd_print_msg "yellow" "Nonexistent directory:")
            __wd_print_msg "normal" (string replace ":" " ->  " $l)
        end
    end
    set n (count $broken_entries)
    if test $n -eq 0
        __wd_print_msg "blue" "No warp points to clean, carry on!"
    else
        if test $argv[1] != "true"
            while true
                read -p "echo -n 'Removing $n warp points. Continue? (Y/n) '" answer
                switch $answer
                    case Y y YES yes Yes ""
                        set answer "yes"
                        break
                    case N n NO no No
                        set answer "no"
                        break
                    case "*"
                        echo "Please provide a valid answer (y or n)"
                end
            end
            if test "$answer" = "no"
                __wd_print_msg "yellow" "Cleanup aborted"
                return
            end
        end
        for entry in $broken_entries
            __wd_remove (string split ":" $entry)[1] >/dev/null
        end
        __wd_print_msg "green" "Clenup complete. $n warp point(s) removed"
    end
end

function __wd_list
    __wd_print_msg "blue" "All warp points:"
    for l in (__wd_read_warprc)
        __wd_print_msg "normal" (printf "%20s  ->  %s" (string split ':' $l))
    end
end

function __wd_warppoints
    for l in (__wd_read_warprc)
        __wd_print_msg "normal" (string split ':' $l)
    end
end

function __wd_warppoints_file
    echo $__wd_warprc
end

function __wd_ls
    set path (__wd_path $argv[1])
    if test -z "$path"
        __wd_exit_nopoint $argv[1]
    else
        ls $path
    end
end

function __wd_path
    set path (string split -m1 "/" $argv[1])
    set found "false"
    for l in (__wd_read_warprc)
        if string match "$path[1]:*" $l >/dev/null
            set found "true"
            if test (count $path) -eq 2
                echo (string split : $l)[2]"/$path[2]"
            else
                echo (string split : $l)[2]
            end
        end
    end
    if test $found = "false" 
        set __wd_exit_status 1
    end
end

function __wd_remove
    if string match "*/*" $argv[1] >/dev/null
        __wd_exit_fail "Warp point cannot contain '/'"
        return
    end
    set path (__wd_path $argv[1])
    if test -n "$path"
        if sed -n "/^$argv[1]:.*\$/!p" $__wd_warprc > $__wd_warprc.tmp; and mv $__wd_warprc.tmp $__wd_warprc
            __wd_print_msg "green" "Warp point $argv[1] removed"
        else
            __wd_exit_fail "Unable to delete warp point!"
        end
    else
        __wd_exit_nopoint $argv[1]
    end
end

function __wd_show
    if test -n "$argv[1]"
        if string match "*/*" $argv[1] >/dev/null
            __wd_exit_fail "Warp point cannot contain '/'"
            return
        end
        set path (__wd_path $argv[1])
        if test -n "$path"
            echo -n (__wd_print_msg "green" "Warp point:")
            __wd_print_msg "normal" "$argv[1] -> $path"
        else
            __wd_exit_nopoint $argv[1]
        end
    else
        for l in (__wd_read_warprc)
            if string match "*:$PWD" $l >/dev/null
                set matches $matches (string split ":" $l)[1]
            end
        end
        if test (count $matches) -ne 0
            echo -n (__wd_print_msg "blue" (count $matches))
            echo -n (__wd_print_msg "normal" "warp point(s) to current directory:")
            __wd_print_msg "blue" "$matches"
        else
            __wd_exit_fail "No warp points to $PWD"
        end
    end
end

function __wd_warp
    if test $argv[1] = ".."
        popd
    else
        set path (__wd_path $argv[1])
        if test -z "$path"
            __wd_exit_nopoint (string split "/" $argv[1])[1]
        else
            set path (string replace -r "^~" $HOME $path)
            pushd $path
        end
    end
end

function wd --description 'warp directory'
    set __wd_version 0.9

    #parse arguments
    set arguments
    for i in (seq 1 (count $argv))
        switch $argv[$i]
            case -v --version
                __wd_print_msg "normal" "wd version $__wd_version"
                set valid_single_option
            case -f --force
                set force "true"
            case -q --quiet
                set -g quiet
            case -c --config
                set config_set
                set valid_single_option
                set conf_pos (math $i+1)
                if test $conf_pos -gt (count $argv)
                    __wd_exit_fail "'-c' needs a file path as argument"
                    return $__wd_exit_status
                end
                if test -f $argv[$conf_pos]
                    # erase possible old global variable
                    set -e __wd_warprc
                    set -U __wd_warprc $argv[$conf_pos]
                else
                    __wd_print_msg "yellow" "Ignoring -c $argv[$i] because it is not a valid file"
                end
            case '*'
                if set -q config_set
                    set -e config_set
                else
                    set arguments $arguments $argv[$i]
                end
        end
    end

    # find warppoints
    if not set -q __wd_warprc; or not test -f $__wd_warprc
        if set -q WARP_FILE
            set -g __wd_warprc $WARP_FILE

        # search XDG_DATA_DIRS
        else if set -q XDG_DATA_DIRS
            for dir in $XDG_DATA_DIRS
                if test -f $dir/wd/warppoints
                    set -g __wd_warprc $dir/wd/warppoints
                    break
                end
            end

        # search XDG_DATA_HOME
        else if set -q XDG_DATA_HOME; and test -f $XDG_DATA_HOME/wd/warppoints
            set -g __wd_warprc $XDG_DATA_HOME/wd/warppoints

        # search XDG_DATA_HOME default: ~/.local/share
        else if test -f $HOME/.local/share/wd/warppoints
            set -g __wd_warprc $HOME/.local/share/wd/warppoints

        # look for old warprc file
        else if test -f $HOME/.warprc
            set -g __wd_warprc "$HOME/.warprc"
            __wd_print_msg "red" "Warp point file location: $HOME/.warprc is deprecated!"
            if set -q XDG_DATA_HOME
            	__wd_print_msg "red" "Please use $XDG_DATA_HOME/wd/warppoints instead."
            else
            	__wd_print_msg "red" "Please use $HOME/.local/share/wd/warppoints instead."
            end
        end

        # Silently create warppoint file in XDG_DATA_HOME
        if not set -q __wd_warprc
            set prefix $XDG_DATA_HOME
            test -z $pefix; and set prefix $HOME/.local/share/wd

            mkdir -p $prefix
            touch $prefix/warppoints

            set -g __wd_warprc $prefix/warppoints
        end
    end

    # set exit status
    set -g __wd_exit_status 0

    # check if 'help' appears first -> don't parse $argv
    if begin test (count $argv) -eq 0
             or test $argv[1] = "help"
             end
        switch (count $argv)
        case 0 1
            __wd_help ""
            return
        case 2
            __wd_help $argv[2]
            return
        end
        __wd_print_msg "red" "help only takes one argument."
        return
    end

    if test (count $arguments) -eq 0
        if not set -q valid_single_option
            __wd_help ""
        end
    else if test (count $arguments) -eq 1
        switch $arguments[1]
            case add
                __wd_exit_fail "You must enter a warp point"
            case add!
                __wd_exit_fail "You must enter a warp point"
            case rm
                __wd_exit_fail "You must enter a warp point"
            case show
                __wd_show
            case list
                __wd_list
            case warppoints
                __wd_warppoints
            case warppoints-file
                __wd_warppoints_file
            case ls
                __wd_exit_fail "You must enter a warp point"
            case path
                __wd_exit_fail "You must enter a warp point"
            case clean
                __wd_clean "false"
            case clean!
                __wd_clean "true"
            case '*'
                __wd_warp $arguments[1]
        end

    else if test (count $arguments) -eq 2
        switch $arguments[1]
            case add
                __wd_add "$force" $arguments[2]
            case add!
                __wd_add "true" $arguments[2]
            case rm
                __wd_remove $arguments[2]
            case show
                __wd_show $arguments[2]
            case list
                __wd_list
                __wd_exit_warn "Command takes no argument. Ignoring '$arguments[2]'"
            case warppoints
                __wd_warppoints
                __wd_exit_warn "Command takes no argument. Ignoring '$arguments[2]'"
            case warppoints-file
                __wd_warppoints_file
                __wd_exit_warn "Command takes no argument. Ignoring '$arguments[2]'"
            case ls
                __wd_ls $arguments[2]
            case path
                __wd_path $arguments[2]
            case clean
                __wd_clean "$force"
                __wd_exit_warn "Command takes no argument. Ignoring '$arguments[2]'"
            case clean!
                __wd_clean "true"
                __wd_exit_warn "Command takes no argument. Ignoring '$arguments[2]'"
            case '*'
                __wd_exit_fail "You can only warp to one point at once."
        end
    else
        __wd_exit_fail "No command uses 2 or more arguments."
    end

    #unset global variables
    if set -q quiet
        set -e quiet
    end

    # unset __wd_exit_status
    set es $__wd_exit_status
    set -e __wd_exit_status

    return $es
end
