# Session Reflection Analysis

Analyze recent chat history to identify improvement opportunities and reduce token waste in future sessions.

## Overview

This skill helps identify patterns of inefficiency in Claude Code sessions by analyzing session history. The analysis focuses on actionable improvements to documentation, automation, and workflows.

## Step 1: Generate Session Summary

**CRITICAL**: Do NOT read raw session files directly. They are massive and will consume your entire token budget.

Instead, use jq to generate a 98% token-reduced summary:

```bash
# Find project folder and summarize recent sessions
PROJECT_DIR="$HOME/.claude/projects/C--Users-Nat-source-Encarta"
OUTPUT="/tmp/session-summary.jsonl"

# Summarize: extract user requests, tool names, assistant text (truncated)
cat "$PROJECT_DIR"/*.jsonl 2>/dev/null | jq -c '
select(.type == "user" or .type == "assistant") |
{
  type,
  ts: .timestamp,
  content: (
    if .message.content | type == "string" then
      .message.content[0:300]
    elif .message.content | type == "array" then
      [.message.content[] |
        if .type == "text" then {t: "text", v: .text[0:300]}
        elif .type == "tool_use" then {t: "tool", v: .name}
        elif .type == "tool_result" then {t: "result", len: (.content | length)}
        elif .type == "thinking" then empty
        else {t: .type}
        end
      ]
    else null
    end
  )
}' > "$OUTPUT" 2>/dev/null

echo "Summary: $(wc -l < "$OUTPUT") messages, $(wc -c < "$OUTPUT" | xargs) bytes"
```

This extracts:
- User message text (first 300 chars)
- Tool calls (name only, not full output)
- Tool result sizes (not content)
- Timestamps for sequence analysis

## Step 2: Launch Subagent for Analysis

Use the Skill tool or a subagent system to analyze `/tmp/session-summary.jsonl` (NOT the raw files).

The subagent should:

### A. Read the Summary

```bash
# Read the generated summary
cat /tmp/session-summary.jsonl
```

### B. Analyze for Inefficiency Patterns

Look for these common patterns:

| Pattern | Example | Impact |
|---------|---------|--------|
| **Wasted tokens** | Re-reading same file 5+ times | High |
| **Wrong paths taken** | Implemented feature, then discovered legacy code that solved it differently | Medium-High |
| **Repeated mistakes** | Same type of error in 3+ separate instances | Medium |
| **Missing automation** | Manual steps repeated across sessions | Medium |
| **Missing documentation** | Had to figure out something that should be in CLAUDE.md | Medium |
| **Unnecessary tool calls** | Called multiple tools when one would work | Low-Medium |
| **Context loss after compaction** | Information that should survive in persistent docs | High |
| **Assumption without verification** | Made architectural decisions without checking existing code first | High |

### C. Propose Improvements

For each pattern found, propose ONE OR MORE of:

1. **CLAUDE.md updates** - Project instructions that prevent repeat mistakes
2. **New skills** - Reusable workflows for `.claude/skills/`
3. **New commands** - Slash commands for `.claude/commands/`
4. **Script automation** - PowerShell/bash scripts to automate manual steps
5. **Git hooks** - Automation that runs on commits/checkouts
6. **Workflow changes** - Process improvements

### D. Create Reflection Document

Generate a document at `session-reflection-YYYY-MM-DD.md` with this structure:

```markdown
# Session Reflection: YYYY-MM-DD

## Summary Statistics
- Session date range: [start] to [end]
- Messages analyzed: [count]
- Major inefficiencies found: [count]

## Proposed Improvements

### High Priority

#### 1. [Problem Title]

**Problem observed**: [What went wrong or was inefficient - be specific with examples]

**Proposed solution**:
```
[Complete text/code to add or change - copy-paste ready]
```

**File to modify**: `path/to/file.md`

**Cost**: [Effort to implement, any downsides]

**Benefit**: [Time/tokens saved, errors prevented - quantify if possible]

---

#### 2. [Next high priority item]
...

### Medium Priority
...

### Low Priority
...

## Implementation Notes

[Any cross-cutting concerns, dependencies between changes, or warnings]
```

## Step 3: Present Findings

After the subagent completes:

1. **Summarize key findings** - 3-5 bullet points of major inefficiencies
2. **Show the reflection document path** - Where to find full details
3. **Ask which changes to implement** - Don't auto-implement

## Critical Rules

1. **NEVER read raw session files directly** - Always use the jq summary
2. **NEVER implement changes automatically** - Only propose them
3. **Make proposals copy-paste ready** - Complete text, not descriptions
4. **Quantify impact when possible** - "Saved 10K tokens" not "saves tokens"
5. **Be specific with examples** - "Re-read encarta.py 7 times" not "read files multiple times"

## Example Analysis Output

```
High Priority Issues Found:

1. **Re-reading encarta.py repeatedly** (7 times in one session)
   - Propose: Add key algorithm summaries to CLAUDE.md
   - Benefit: Save ~15K tokens per session

2. **Implemented PhraseDecompress without checking DLL first**
   - Took 3 iterations to match actual behavior
   - Propose: Add "Check legacy code FIRST" rule to CLAUDE.md
   - Benefit: Prevent wrong-path implementations

3. **Manual ISO mount/unmount**
   - Repeated PowerShell commands each session
   - Propose: Create /mount-iso and /unmount-iso commands
   - Benefit: Save 2-3 minutes per session, prevent errors
```

## Integration with deciduous

This reflection analysis complements deciduous decision tracking:

- **deciduous**: Records decisions and reasoning (graph structure)
- **session-reflection**: Identifies process improvements (retrospective analysis)

After generating a reflection, consider updating deciduous with any major architectural decisions discovered during the analysis.
