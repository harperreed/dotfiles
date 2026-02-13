# ~/.config/fish/functions/startwork-mosh.fish
function startwork-mosh --description "mosh <host> and run fish function utm (default host: disaster)"
  # Usage: startwork-mosh [host]
  set -l host disaster
  if test (count $argv) -ge 1
    set host $argv[1]
  end

  # Phrases and matching emojis for random selection
  set -l phrases 'B E A S T   M O D E' 'S E N D   I T' 'L F G' 'H A C K   T H E   P L A N E T' 'F U L L   S E N D' 'L O C K   I N' 'L E T S   G O O O' 'G O   T I M E' 'Y E E T' 'N O   S L E E P   T I L L   P R O D'
  set -l emojis '🔥' '⚡' '🚀' '💀' '🏁' '🧠' '🎯' '⏰' '🫡' '💣'
  set -l pick (random 1 (count $phrases))
  set -l bar_colors brred bryellow brgreen brcyan brblue brmagenta

  echo
  # Top rainbow bar
  for _r in (seq 1 6)
    for c in $bar_colors
      set_color $c
      printf '▓▒'
    end
  end
  printf '\n'

  # Phrase line
  echo
  set_color --bold $bar_colors[(random 1 (count $bar_colors))]
  echo "      $emojis[$pick]  $phrases[$pick]  $emojis[$pick]"
  echo
  set_color normal

  # Bottom rainbow bar
  for _r in (seq 1 6)
    for c in $bar_colors
      set_color $c
      printf '▒▓'
    end
  end
  printf '\n'
  echo

  # Connection info
  set_color --bold bryellow
  echo "      ⮕  $host"
  set_color normal
  echo

  mosh $host -- fish -lc 'utm'

  # Disconnect banner
  set -l bye_phrases 'P E A C E   O U T' 'G G' 'T O U C H   G R A S S' 'L A T E R   N E R D' 'A I G H T   I M M A   H E A D   O U T' 'S E S H   O V E R' 'C L O C K E D   O U T' 'B Y E   F E L I C I A' 'G O N E   F I S H I N' 'C T R L + D   E N E R G Y'
  set -l bye_emojis '✌️' '🎮' '🌿' '🤓' '🚪' '⏹️' '🕐' '👋' '🎣' '⌨️'
  set -l bye_pick (random 1 (count $bye_phrases))

  echo
  # Dim disconnect bar
  for _r in (seq 1 6)
    for c in $bar_colors
      set_color $c
      printf '░░'
    end
  end
  printf '\n'

  echo
  set_color --bold $bar_colors[(random 1 (count $bar_colors))]
  echo "      $bye_emojis[$bye_pick]  $bye_phrases[$bye_pick]  $bye_emojis[$bye_pick]"
  echo
  set_color normal

  for _r in (seq 1 6)
    for c in $bar_colors
      set_color $c
      printf '░░'
    end
  end
  printf '\n'
  echo

  set_color --bold brred
  echo "      ⮕  disconnected from $host"
  set_color normal
  echo
end

