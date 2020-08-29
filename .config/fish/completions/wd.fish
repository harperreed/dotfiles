function __wd_no_command
    set cmd (commandline -opc)
    test (count $cmd) -eq 1
    return
end

function __wd_using_command
    set cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $argv[1] = $cmd[2]
            return 0
        end
    end
    return 1
end

function __wd_complete_warppoints
   echo (cat (wd -q warppoints-file) | cut -d : -f 1)
end

#Options
complete -c wd -s q -l quiet -f -d "Suppress all output"
complete -c wd -s c -l config -r -d "Specify and set config file"
complete -c wd -s v -l version -f -d "Print version"
complete -c wd -s f -l force -d "Equivalent to ! (add | clean)"

#Warp points
complete -c wd -n '__wd_no_command' -f -d "Warp point" -a (__wd_complete_warppoints)
#Commands
complete -c wd -n '__wd_no_command' -x -d "Go back in the directory stack" -a ".."
complete -c wd -n '__wd_no_command' -x -d "Adds the current working directory to your warp points" -a "add"
complete -c wd -n '__wd_no_command' -x -d "Overwrites existing warp point" -a "add!"
complete -c wd -n '__wd_no_command' -x -d "Removes the given warp point" -a "rm"
complete -c wd -n '__wd_no_command' -x -d "Outputs all warp points to the current directory or the target of one specific point" -a "show"
complete -c wd -n '__wd_no_command' -x -d "Outputs all stored warp points" -a "list"
complete -c wd -n '__wd_no_command' -x -d "Outputs all warp point names " -a "warppoints"
complete -c wd -n '__wd_no_command' -x -d "Print path where warp points are stored" -a "warppoints-file"
complete -c wd -n '__wd_no_command' -x -d "Outputs all stored warp points" -a "list"
complete -c wd -n '__wd_no_command' -x -d "Show file from given warp point" -a "ls"
complete -c wd -n '__wd_no_command' -x -d "Output path to given warp point" -a "path"
complete -c wd -n '__wd_no_command' -x -d "Remove warp points to nonexistent directories" -a "clean"
complete -c wd -n '__wd_no_command' -x -d "Remove warp points to nonexistent directories without confirmation" -a "clean!"

#Command specific completions
complete -c wd -x -n '__wd_using_command rm' -d "Warp point" -a (__wd_complete_warppoints)
complete -c wd -x -n '__wd_using_command show' -d "Warp point" -a (__wd_complete_warppoints)
complete -c wd -x -n '__wd_using_command ls' -d "Warp point" -a (__wd_complete_warppoints)
complete -c wd -x -n '__wd_using_command path' -d "Warp point" -a (__wd_complete_warppoints)
