# remote-system-maintenance Skill

## Summary

Reference skill providing structured checklists and patterns for diagnosing and maintaining remote Linux systems (Ubuntu/Debian focus) via tmux.

## Created

- **Date**: 2025-11-20
- **Origin**: Extracted from successful maintenance session on stolen-imac
- **Development Method**: TDD for skills (RED-GREEN-REFACTOR)

## Skill Type

**REFERENCE/TECHNIQUE** - Provides checklists, patterns, and templates rather than enforcing discipline.

## Key Value

1. **Complete cleanup checklist**: APT cache, journal logs, snap revisions, temp files
2. **Snap revision pattern**: Specific commands to find and remove disabled snap revisions (~500MB-2GB savings)
3. **Log file template**: Structured format with quantification requirements
4. **Typical space savings**: Per-category estimates to set expectations
5. **Diagnostic procedures**: Systematic approach to system health assessment

## Validation

Validated against real successful maintenance session (stolen-imac, 2025-11-18):
- Freed ~2GB total (616MB journal, 1.5GB snaps, 2.3MB apt)
- All operations in the skill checklist were performed
- Log structure matched template
- Results were properly quantified

## Files

- `SKILL.md` - Main reference (798 words, self-contained)
- `test-scenarios.md` - Initial pressure test scenarios (RED phase)
- `baseline-results.md` - Baseline testing results and analysis
- `green-phase-results.md` - Validation results with skill
- `quality-check.md` - Final quality checklist
- `README.md` - This file

## Usage

Future Claude instances will discover this skill when users request:
- "Clean up the Ubuntu server"
- "System is low on disk space"
- "Perform system maintenance on [machine]"
- "Diagnose remote system health"

The skill provides comprehensive checklists and patterns that weren't available in CLAUDE.md.

## Testing Notes

**Challenge encountered**: Subagents refuse hypothetical scenarios and demand real work context.

**Solution**: Validated skill by comparing against actual successful maintenance session rather than synthetic subagent tests. For REFERENCE skills, this is acceptable validation.

**Finding**: Base agents with CLAUDE.md are already safety-conscious (refuse to cut corners under pressure). The skill adds VALUE through comprehensive knowledge (what to clean, how much space typically freed, snap revision pattern, log structure) rather than safety reminders.
