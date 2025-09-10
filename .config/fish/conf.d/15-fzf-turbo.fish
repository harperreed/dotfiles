# ABOUTME: FZF configuration with turbo defaults and specialized file/content pickers
# ABOUTME: Uses fd/rg for blazing fast fuzzy finding with preview support

# Use fd/rg under fzf by default (fast, respects .gitignore)
if type -q fd
  set -gx FZF_DEFAULT_COMMAND  'fd --type f --hidden --follow --exclude .git'
  set -gx FZF_CTRL_T_COMMAND   $FZF_DEFAULT_COMMAND
  set -gx FZF_ALT_C_COMMAND    'fd --type d --hidden --follow --exclude .git'
end

# Sensible fzf defaults (merge with plugin if present)
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# fzf: open a file in nvim with preview
function vf --description 'fzf pick → nvim'
  set -l f (eval $FZF_DEFAULT_COMMAND | fzf --preview 'bat --style=numbers --color=always {}' --ansi)
  test -n "$f"; and nvim $f
end

# fzf: ripgrep results → open at exact line
function rgf --description 'ripgrep + fzf → nvim at line'
  set -l q (string join ' ' $argv)
  set -l sel (rg --no-heading --line-number --hidden -g '!.git' --color=never "$q" \
    | fzf --ansi --prompt="RG> " --preview 'bat --style=numbers --color=always {1} --line-range {2}:+' \
            --delimiter : --nth=1,2,3)
  test -z "$sel"; and return
  set -l file (echo $sel | cut -d: -f1)
  set -l line (echo $sel | cut -d: -f2)
  nvim +"normal! ${line}Gzz" "$file"
end