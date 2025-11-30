---
name: remote-system-maintenance
description: Use when performing system maintenance or diagnostics on remote Linux systems via tmux - provides structured checklists for Ubuntu/Debian cleanup (apt, journal, snap revisions), diagnostic procedures, and log file templates with quantification patterns
---

# Remote System Maintenance

## Overview

Structured checklist for diagnosing and maintaining remote Linux systems accessed via tmux. Focuses on Ubuntu/Debian systems with comprehensive cleanup procedures and proper documentation.

## When to Use

**Use when:**
- Performing system maintenance on remote Linux systems
- System running low on disk space
- Need to update packages and clean up caches
- Diagnosing system health via SSH/tmux
- User asks to "clean up" or "maintain" a remote system

**Don't use for:**
- Local system maintenance (direct terminal access)
- Non-Linux systems
- When you don't have tmux session context

## Quick Reference: Ubuntu/Debian Cleanup Checklist

| Category | Commands | Typical Space Freed |
|----------|----------|-------------------|
| APT cache | `apt clean`, `apt autoremove -y` | 100-500 MB |
| Journal logs | `journalctl --vacuum-time=7d` | 300-600 MB |
| Snap revisions | Remove disabled revisions | 500 MB-2 GB |
| Temp files | `/tmp`, `/var/tmp`, `~/.cache` | 50-200 MB |

**Always quantify results:** Report before/after disk usage and MB/GB freed per category.

## Diagnostic Procedure

### 1. Initial State Capture (5 min)

```bash
# System identity
hostname && uname -a

# Resource status
df -h
free -h
uptime

# Process health
ps aux --sort=-%mem | head -15
ps aux | awk '$8 ~ /Z/ { print }'  # Check for zombies
```

**Log to:** `./logs/HOSTNAME.log` (start immediately)

### 2. Review System Logs (5 min)

```bash
# Recent errors
journalctl -p err -n 30 --no-pager

# Disk usage by journal
journalctl --disk-usage
```

### 3. Package Status (5 min)

```bash
# Check for updates
sudo apt update
apt list --upgradable

# Check for orphaned packages
dpkg -l | grep "^rc"  # Removed but config remains
```

## Ubuntu/Debian Cleanup Procedure

### Safe Cleanup Sequence

```bash
# 1. Update package cache
sudo apt update

# 2. Upgrade packages
apt list --upgradable  # Review first
sudo apt upgrade -y

# 3. Remove orphaned packages
sudo apt autoremove -y

# 4. Clean package cache
sudo apt clean
du -sh /var/cache/apt/archives  # Verify

# 5. Clean journal logs (keep 7 days)
sudo journalctl --vacuum-time=7d

# 6. Clean snap revisions (Ubuntu-specific)
snap list --all | awk '/disabled/{print $1, $3}'  # List disabled
# Remove each disabled revision:
snap list --all | awk '/disabled/{print $1, $3}' | \
  while read snapname revision; do
    sudo snap remove "$snapname" --revision="$revision"
  done

# 7. Check temp directories
du -sh /tmp /var/tmp ~/.cache

# 8. Final disk check
df -h /
```

### Snap Revision Cleanup Pattern

**Key insight:** Snap keeps old revisions by default. Must remove explicitly by revision number.

```bash
# Find disabled snap revisions
snap list --all | awk '/disabled/{print $1, $3}'

# Remove all disabled revisions
snap list --all | awk '/disabled/{print $1, $3}' | \
  while read snapname revision; do
    sudo snap remove "$snapname" --revision="$revision"
  done
```

**Typical savings:** 500 MB - 2 GB depending on number of snaps and update frequency.

## Log File Structure

Create `./logs/HOSTNAME.log` with this structure:

```markdown
# Maintenance Log for HOSTNAME
# Started: YYYY-MM-DD

## Session Information
- Hostname: [hostname]
- OS: [os-version]
- Kernel: [kernel-version]
- Operator: [user]
- Connection: SSH via tmux session X

## Initial State
- Disk: XGB used / YGB total (Z% utilization)
- Memory: XGB used / YGB total
- Load Average: X.XX
- Uptime: X hours/days

## Diagnostic Results
### System Health
- [findings]

### Log Analysis
- [errors or issues found]

## Actions Performed
### Package Updates
- Packages upgraded: [list or count]
- Security updates: [count]

### Cleanup Operations
- APT cache: X MB freed
- Journal logs: X MB freed
- Snap revisions: X MB freed
- Total space freed: ~X GB

## Final Status
- Disk usage: XGB / YGB (Z%)
- All diagnostics passed / Issues found
- Reboot required: yes/no

## Recommendations
- [any follow-up needed]
```

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Skip before/after disk comparison | Always run `df -h /` before and after cleanup |
| Miss snap revisions | Check `snap list --all` for disabled revisions |
| Forget to quantify | Report specific MB/GB freed per category |
| Incomplete log | Use the log structure template |
| Skip journal vacuum | Can free 300-600 MB, check `journalctl --disk-usage` |

## Real-World Example

From actual session (stolen-imac):
- **Journal vacuum**: 616.4 MB freed (22 old log files)
- **Snap cleanup**: ~1.5 GB freed (18 disabled revisions)
- **APT cleanup**: 2.3 MB (orphaned packages)
- **Total**: ~2 GB disk space recovered
- **Time**: 45 minutes including diagnostics and documentation
