# Blink Shell Optimizations

Mobile-friendly enhancements for using Fish shell in Blink Shell on iOS/iPadOS.

## Features

### 🎨 Compact Prompt
- Single-line prompt that saves screen space
- Shows only essential info (cwd, git branch)
- Automatically enabled when Blink Shell is detected

### ⚡ Performance Mode
- Toggle git checks on/off with `blink_fast`
- Useful for slow/cellular connections
- Speeds up prompt rendering

### 📱 Touch-Friendly tmux
- Larger pane borders for easier touch targeting
- Quick zoom with `Ctrl-a z`
- Alt+Arrow for window switching
- Better mouse/touch scrolling

### 🚀 Enhanced Connection Management

#### Basic Commands
- `w hostname` - Connect via mosh to host (creates/attaches tmux session "main")
- `w hostname session` - Connect to specific tmux session
- `wr` - Reconnect to last host/session
- `ws hostname` - Plain SSH connection
- `wl` - List all configured hosts from SSH config
- `wq` - Interactive host selector with fzf

#### Examples
```fish
# Connect to godzilla, main session
w godzilla

# Connect to occult, dev session
w occult dev

# Quick reconnect after disconnect
wr

# List available hosts
wl

# Interactive host picker
wq
```

### 📋 Clipboard Integration
- `copy` - Copy stdin to iOS clipboard
- `copy file.txt` - Copy file contents
- `paste` - Paste from clipboard

### 🔧 Useful Shortcuts
- `t sessionname` - Attach to tmux session
- `tn sessionname` - Create new tmux session
- `tl` - List tmux sessions
- `m hostname` - Quick mosh (abbreviation)

## Configuration Files

- `~/.config/fish/conf.d/95-blink.fish` - Blink-specific settings
- `~/.config/fish/conf.d/82-tmux.fish` - Enhanced mosh/tmux helpers
- `~/.tmux.conf` - Touch-friendly tmux settings (see BLINK SHELL section)

## Tips

### For Slow Connections
1. Enable fast mode: `blink_fast`
2. This disables git status checks in prompt
3. Toggle back when on fast WiFi

### Session Management
1. Use `w hostname` for your first connection
2. Get disconnected? Just type `wr` to reconnect
3. Use `wl` to see all your configured hosts

### tmux on Mobile
- Use `Ctrl-a z` to zoom/unzoom panes (makes reading easier)
- Swipe left/right (Alt+Arrow) to switch windows
- `Ctrl-a S` for session tree view
- Mouse support is enabled - tap to select panes

### Orientation Changes
- `Ctrl-a Space` cycles through layouts
- Useful when rotating iPad/iPhone

## Troubleshooting

### Mosh not connecting?
- Check mosh is installed on remote: `ssh host 'which mosh'`
- Fallback to SSH: `ws hostname`
- Check firewall allows UDP 60000-61000

### Prompt too long?
- Enable fast mode: `blink_fast`
- Or edit `~/.config/fish/conf.d/95-blink.fish`

### First Time Setup
Run on remote servers:
```bash
# Install mosh
sudo apt install mosh  # Debian/Ubuntu
sudo yum install mosh  # CentOS/RHEL
brew install mosh      # macOS

# Install tmux
sudo apt install tmux  # Debian/Ubuntu
sudo yum install tmux  # CentOS/RHEL
brew install tmux      # macOS
```

## Auto-Detection

The config automatically detects Blink Shell via `$TERM_PROGRAM` environment variable. All optimizations only activate when running in Blink.

Desktop terminals will use the standard verbose prompt with full git info.
