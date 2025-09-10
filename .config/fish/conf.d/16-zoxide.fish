# ABOUTME: Zoxide configuration for fast directory jumping
# ABOUTME: Provides z command for smart cd and zi for fuzzy directory selection

if type -q zoxide
  zoxide init fish | source
  function zi --description 'zoxide + fzf'
    set -l d (zoxide query -l | fzf --prompt="z> ")
    test -n "$d"; and cd "$d"
  end
end