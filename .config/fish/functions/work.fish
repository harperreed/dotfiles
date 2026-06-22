# ~/.config/fish/functions/work.fish
function work --description "ssh -t <host> and run utm (default), herdr, or boo ui"
  # Usage: work [--herdr|--boo] [host]
  argparse 'herdr' 'boo' -- $argv
  or return

  if set -q _flag_herdr; and set -q _flag_boo
    set_color brred
    echo "💀 work: --herdr and --boo are mutually exclusive"
    set_color normal
    return 2
  end

  set -l host disaster
  if test (count $argv) -ge 1
    set host $argv[1]
  end

  set -l remote_cmd utm
  if set -q _flag_herdr
    set remote_cmd uhm
  else if set -q _flag_boo
    set remote_cmd 'boo ui'
  end

  # Phrases and matching emojis for random selection
  set -l phrases 'G O B L I N   M O D E   E N G A G E D' 'F E R A L   K E Y B O A R D   H O U R' 'S U M M O N I N G   T H E   D A E M O N S' 'T H E   K E R N E L   P A N I C S   F I R S T' 'C E R T I F I E D   C U R S E D   E N E R G Y' 'B O N E L E S S   D E P L O Y   T O   P R O D' 'N E C R O M A N C I N G   A   D E A D   B R A N C H' 'B I G F O O T   S T O M P S   T H E   S E R V E R' 'C O M M I T T I N G   C R I M E S   I N   M A I N' 'R E L E A S E   T H E   D O O M S L U G' 'C R A C K E D   O U T   O N   S E M I C O L O N S' 'P R A Y I N G   T O   T H E   L I N K E R' 'N O   G O D S   N O   T E S T S' 'L I C E N S E   T O   K E R N E L' 'B A B Y G I R L   I T S   R E F A C T O R   O C L O C K' 'F O U R   L O K O   F U E L E D   M E R G E' 'R A C C O O N   I N   T H E   S E R V E R   R O O M' 'F R E A K Y   F R I D A Y   M E R G E   C O N F L I C T' 'T H E   L O G S   K N O W   W H A T   Y O U   D I D' 'H E A R S E   R O L L I N G   T O   P R O D'
  set -l emojis '👹' '🐺' '😈' '💥' '🔮' '🍗' '🪦' '🦶' '🔪' '🐉' '💊' '🙏' '⚰️' '🔑' '💅' '🧃' '🦝' '🎭' '👁️' '🏴'
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

  ssh -t $host "fish -lc '$remote_cmd'"

  # Disconnect banner
  set -l bye_phrases 'V A N I S H I N G   I N T O   T H E   M I S T' 'S K I L L   I S S U E   R E S O L V E D' 'G R E M L I N   G O E S   N I G H T   N I G H T' 'R E T U R N I N G   T O   T H E   S W A M P' 'D A E M O N S   E X O R C I S E D' 'B U R Y I N G   T H E   L A P T O P   I N   T H E   Y A R D' 'M Y   B O N E S   H U R T' 'A B A N D O N I N G   T H E   B O D Y' 'B U R Y I N G   T H E   M E R G E   C O N F L I C T' 'A B S O L U T E L Y   C O O K E D' 'B R B   B E C O M I N G   A   T R E E' 'C R A W L I N G   B A C K   I N T O   T H E   E G G' 'L O G S   R O T A T E D   B R A I N   R O T A T E D' 'P O W E R I N G   D O W N   T H E   M E A T   S U I T' 'C R A W L I N G   I N T O   T H E   S O I L' 'L E A V I N G   I N   A   B O D Y   B A G' 'T H E   R I T U A L   I S   C O M P L E T E' 'D I S S O L V I N G   I N T O   S T A T I C' 'T E R M I N A L   V E L O C I T Y   A C H I E V E D' 'L A S T   R I T E S   F O R   T H E   S E S S I O N'
  set -l bye_emojis '🌫️' '🩹' '😴' '🐊' '⛪' '⚰️' '💀' '👻' '🪦' '🔥' '🌳' '🥚' '🧠' '🥩' '🪱' '🚑' '🕯️' '📺' '⌨️' '⚱️'
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
