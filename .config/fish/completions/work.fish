# ABOUTME: Tab completion for the work function: transport/ui flags plus hostnames.
# ABOUTME: Hosts come from __fish_print_hostnames (ssh config + known_hosts).
complete -c work -f
complete -c work -s h -l help -d 'show usage'
complete -c work -l mosh -d 'connect with mosh instead of ssh'
complete -c work -l herdr -d 'run herdr on the remote'
complete -c work -l boo -d 'run boo ui on the remote'
complete -c work -a '(__fish_print_hostnames)' -d host
