function ssh-password --wraps='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no' --description 'alias ssh-password ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
    ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no $argv
end
