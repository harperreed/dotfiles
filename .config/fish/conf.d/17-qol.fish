# ABOUTME: Quality of life improvements for better man pages, clipboard, and Quick Look
# ABOUTME: Enhanced terminal experience with colored output and macOS integration

# Pretty man pages with bat
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Less: colors, mouse, and no history file
set -gx LESS '-R --mouse --wheel-lines=3'
set -gx LESSHISTFILE '-'

# macOS clipboard helpers
function cb --description 'copy stdin/file to clipboard'
  if test (count $argv) -gt 0
    cat $argv | pbcopy
  else
    pbcopy
  end
end

function pb --description 'paste clipboard to stdout'
  pbpaste
end

# Quick Look preview: ql <file>
function ql --description 'Quick Look a file'
  test -e "$argv[1]"; and qlmanage -p "$argv[1]" >/dev/null 2>&1 &
end