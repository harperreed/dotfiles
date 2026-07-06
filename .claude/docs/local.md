<!-- ABOUTME: Machine-specific facts for this Mac — expected to rot; re-verify when auditing -->
<!-- ABOUTME: Evergreen rules live in ~/.claude/CLAUDE.md; only environment facts belong here -->

# Local environment (verified: 2026-07-05)

- macOS (darwin), Homebrew at /opt/homebrew. My shell is fish — not bash or zsh.
- I am often interacting with you remotely: localhost links will not work for me. Send tailscale IPs instead — this machine has a live tailscale interface in the 100.x.y.z range (`ifconfig | grep "inet 100\."`).
- Installed and available: sg/ast-grep, uv/uvx, jq, gh. timeout/gtimeout exist here via Homebrew, but avoid them — they are not reliably present on other machines.
- MCP servers on this machine: bbs (team bulletin board — check it when asked, leave notes for other agents and humans), chronicle (activity log), pulse (journal + team posts).
