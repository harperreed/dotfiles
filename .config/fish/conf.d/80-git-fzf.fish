# ABOUTME: Git superpowers using fzf for branch and stash management
# ABOUTME: Interactive git operations with preview and fuzzy selection

# fzf checkout: local or remote branches
function gco --description 'fzf checkout branch'
  git rev-parse --git-dir >/dev/null 2>&1; or return 1
  set -l b (git branch --all --color=always | sed 's/^[* ]*//' | string trim | sort -u \
           | fzf --ansi --prompt='git-checkout> ' \
                 --preview 'git log --oneline --graph --decorate --color=always {} -n 25' )
  test -z "$b"; and return
  git checkout (string replace -r '^remotes/[^/]+/' '' -- $b)
end

# fzf apply stash
function gstash --description 'fzf pick stash to apply/show'
  git rev-parse --git-dir >/dev/null 2>&1; or return 1
  set -l s (git stash list | fzf --prompt='stash> ' --preview 'git stash show -p --color=always {1}')
  test -z "$s"; and return
  set -l name (echo $s | cut -d: -f1)
  git stash apply $name
end