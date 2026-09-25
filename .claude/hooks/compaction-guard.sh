#!/bin/bash
# ABOUTME: SessionStart hook for the compact and resume sources. Prints the session's true compaction
# ABOUTME: count, the newest plan doc's "## Now" section, and the retire order once the count hits RETIRE_AT.
#
# Why: compaction summaries paraphrase constraints and lose count of themselves. Claude Code adds
# this hook's stdout to the context after every compaction and on resume, so the count and the plan
# state come from files, not from the summary. Reads the hook JSON on stdin (source, transcript_path,
# cwd, agent_id). Never blocks: every failure path exits 0, with no output.
# Registered in ~/.claude/settings.json (SessionStart, matcher "compact|resume").
# Tests: compaction-guard.test.sh beside this file.

set -u

RETIRE_AT=3
PLAN_DIRS="docs/superpowers/plans docs/plans plans"

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat 2>/dev/null) || exit 0
[ -n "$input" ] || exit 0

# One field per line: a TSV read would collapse the empty agent_id field into its neighbour.
{ read -r source; read -r agent_id; read -r transcript; read -r cwd; } < <(
  printf '%s' "$input" | jq -r '.source // "", .agent_id // "", .transcript_path // "", .cwd // ""' 2>/dev/null
)
[ -z "${agent_id:-}" ] || exit 0
case "${source:-}" in
  compact | resume) ;;
  *) exit 0 ;;
esac

# Each compaction writes one compact_boundary line to the transcript. On the compact source this hook
# runs before Claude Code writes the current compaction's line, so the transcript holds only earlier ones.
count=0
if [ -n "${transcript:-}" ] && [ -f "$transcript" ]; then
  count=$(grep -c -F '"subtype":"compact_boundary"' "$transcript" 2>/dev/null) || count=0
fi
if [ "$source" = compact ]; then
  count=$((count + 1))
fi

# The plan doc is the most recently modified markdown file in the first plan directory that has any,
# searched from the repository root so a session started in a subdirectory still finds it.
root=${cwd:-}
if [ -n "$root" ] && [ -d "$root" ]; then
  root=$(git -C "$root" rev-parse --show-toplevel 2>/dev/null) || root=$cwd
fi
plan=""
set --
for dir in $PLAN_DIRS; do
  for f in "$root/$dir"/*.md; do
    [ -f "$f" ] && set -- "$@" "$f"
  done
done
if [ $# -gt 0 ]; then
  # shellcheck disable=SC2012  # ls -t is the portable mtime sort; names come from a *.md glob
  plan=$(ls -t "$@" 2>/dev/null | head -n 1)
fi

if [ "$source" = compact ]; then
  echo "[compaction-guard] Compaction $count of this session (retire at $RETIRE_AT)."
else
  echo "[compaction-guard] Resumed after $count compactions (retire at $RETIRE_AT)."
fi
if [ "$count" -ge "$RETIRE_AT" ]; then
  echo "RETIRE NOW: finish the current step, commit, update the Now section, then end the turn with the word RETIRED and no next step. Start nothing new."
fi

if [ -n "$plan" ] && grep -q '^## Now' "$plan" 2>/dev/null; then
  echo "Plan doc: $plan"
  awk '/^## Now/ { p = 1; print; next } p && (/^# / || /^## /) { exit } p' "$plan" | head -n 40
elif [ -n "$plan" ]; then
  echo "Plan doc $plan has no '## Now' section. Add one (CLAUDE.md, Session lifecycle) before doing anything else."
else
  echo "No plan doc found under $root (looked in: $PLAN_DIRS)."
fi
echo "The compaction summary is lossy: where it disagrees with the Now section or gotchas.md, the files win. Only approvals quoted in the Now section count."
exit 0
