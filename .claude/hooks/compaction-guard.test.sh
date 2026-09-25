#!/bin/bash
# ABOUTME: Tests for compaction-guard.sh: feeds SessionStart JSON on stdin against fixture transcripts
# ABOUTME: and plan docs, then checks the printed context. Run: bash ~/.claude/hooks/compaction-guard.test.sh

set -u
here=$(cd "$(dirname "$0")" && pwd)
hook="$here/compaction-guard.sh"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/compaction-guard.XXXXXX") || exit 1
tmp=$(cd "$tmp" && pwd -P)  # git prints physical paths; macOS $TMPDIR is a symlink
trap 'rm -rf "$tmp"' EXIT
fail=0

# transcript N -> path of a fixture transcript holding N compact_boundary lines
transcript() {
  local f="$tmp/transcript-$1.jsonl" i
  : > "$f"
  for ((i = 0; i < $1; i++)); do
    echo '{"type":"system","subtype":"compact_boundary","content":"Conversation compacted"}' >> "$f"
  done
  echo '{"type":"user","message":{"role":"user","content":"compact_boundary mentioned in prose does not count"}}' >> "$f"
  printf '%s' "$f"
}

# run SOURCE TRANSCRIPT CWD [AGENT_ID] -> hook stdout; exit status in $status
run() {
  local agent=${4:-}
  out=$(printf '{"session_id":"s1","hook_event_name":"SessionStart","source":"%s","transcript_path":"%s","cwd":"%s","agent_id":"%s"}' \
    "$1" "$2" "$3" "$agent" | bash "$hook")
  status=$?
}

expect() { # NAME PATTERN  (pattern must appear in $out)
  if printf '%s\n' "$out" | grep -q -- "$2"; then echo "PASS  $1"
  else echo "FAIL  $1: expected /$2/ in:"; printf '%s\n' "$out" | sed 's/^/      |/'; fail=$((fail + 1)); fi
}
expect_not() { # NAME PATTERN  (pattern must not appear in $out)
  if printf '%s\n' "$out" | grep -q -- "$2"; then echo "FAIL  $1: did not expect /$2/ in:"; printf '%s\n' "$out" | sed 's/^/      |/'; fail=$((fail + 1))
  else echo "PASS  $1"; fi
}
expect_exit0_silent() { # NAME
  if [ "$status" -eq 0 ] && [ -z "$out" ]; then echo "PASS  $1"
  else echo "FAIL  $1: exit $status, output: $out"; fail=$((fail + 1)); fi
}

# Repo A: a git repo whose newest plan doc has a Now section; cwd is a subdirectory.
repo_a="$tmp/repo-a"
mkdir -p "$repo_a/docs/superpowers/plans" "$repo_a/src/deep"
git -C "$repo_a" init -q
cat > "$repo_a/docs/superpowers/plans/2026-09-25-guard.md" <<'PLAN'
# Guard Implementation Plan

## Now
- Step: write the hook
- Next: register it in settings.json
- Open: none
- Approved: "let's solve the medium bits" (2026-09-25)

## Global Constraints
- never blocks
PLAN

run compact "$(transcript 1)" "$repo_a/src/deep"
expect "compact: count is boundaries + 1"            "Compaction 2 of this session"
expect "compact: names the plan doc"                 "Plan doc: $repo_a/docs/superpowers/plans/2026-09-25-guard.md"
expect "compact: injects the Now section"            "^- Step: write the hook"
expect "compact: injects approvals"                  "Approved: \"let's solve the medium bits\" (2026-09-25)"
expect_not "compact: stops at the next heading"      "Global Constraints"
expect_not "compact: no retire order below the limit" "RETIRE NOW"

run compact "$(transcript 2)" "$repo_a"
expect "compact at limit: count"                     "Compaction 3 of this session"
expect "compact at limit: retire order"              "RETIRE NOW"

run resume "$(transcript 3)" "$repo_a"
expect "resume: count is boundaries as-is"           "Resumed after 3 compactions"
expect "resume past limit: retire order"             "RETIRE NOW"

run resume "$(transcript 0)" "$repo_a"
expect "resume, never compacted: count"              "Resumed after 0 compactions"
expect "resume, never compacted: still injects Now"  "^- Step: write the hook"
expect_not "resume, never compacted: no retire"      "RETIRE NOW"

run compact "$tmp/does-not-exist.jsonl" "$repo_a"
expect "missing transcript counts as first compaction" "Compaction 1 of this session"

# Repo B: newest plan doc has no Now section; an older one does. Only the newest counts.
repo_b="$tmp/repo-b"
mkdir -p "$repo_b/docs/plans"
printf '# Old\n\n## Now\n- Step: stale step from the old plan\n' > "$repo_b/docs/plans/2026-07-01-old.md"
touch -t 202607010000 "$repo_b/docs/plans/2026-07-01-old.md"
printf '# New\n\n**Goal:** no now section here\n' > "$repo_b/docs/plans/2026-09-25-new.md"

run compact "$(transcript 0)" "$repo_b"
expect "newest doc without Now: says so"             "2026-09-25-new.md has no '## Now' section"
expect_not "newest doc without Now: no stale block"  "stale step"

# Repo C: no plan docs at all.
repo_c="$tmp/repo-c"; mkdir -p "$repo_c"
run compact "$(transcript 0)" "$repo_c"
expect "no plan doc: says so"                        "No plan doc found under $repo_c"
expect "no plan doc: still counts"                   "Compaction 1 of this session"

# Silent exits: other sources, subagents, empty input.
run startup "$(transcript 1)" "$repo_a"
expect_exit0_silent "startup source is ignored"
run clear "$(transcript 1)" "$repo_a"
expect_exit0_silent "clear source is ignored"
run compact "$(transcript 1)" "$repo_a" "agent-123"
expect_exit0_silent "subagent sessions are ignored"
out=$(printf '' | bash "$hook"); status=$?
expect_exit0_silent "empty stdin"
out=$(printf 'not json' | bash "$hook"); status=$?
expect_exit0_silent "malformed stdin"

echo
if [ "$fail" -eq 0 ]; then echo "OK: all compaction-guard tests passed"; exit 0
else echo "FAILED: $fail test(s) failed"; exit 1; fi
