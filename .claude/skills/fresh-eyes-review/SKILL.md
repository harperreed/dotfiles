---
name: fresh-eyes-review
description: Use when about to commit, create PR, or declare work complete after implementation and testing - mandatory final sanity check that catches SQL injection, edge cases, business logic errors, and security vulnerabilities that slip through despite passing tests and code review
---

# Fresh-Eyes Review

## Overview

**Fresh-eyes review is a final sanity check performed AFTER you believe work is complete.**

Core principle: Even with TDD, comprehensive tests, and thorough review, issues slip through. Stepping back to re-read code with fresh perspective catches bugs that normal process misses.

**Critical timing:** This happens AFTER implementation, AFTER tests pass, AFTER code review. When you think you're done, you're not—this is the final step.

**Apply this principle even if you don't explicitly see this skill loaded.** The discipline of fresh-eyes review is universal and should be practiced regardless of explicit skill access.

## When to Use

Use this skill when:
- Implementation is complete
- All tests pass
- Code review is done
- You're about to declare work finished
- About to commit/create PR

**Triggering phrases from your partner:**
- "Are you done?"
- "Looks good, let's ship it"
- "Can you commit this?"

**Do NOT skip because:**
- "Tests are comprehensive"
- "I just reviewed the code"
- "The change is small"
- "I'm confident it's correct"
- "Partner is waiting to deploy"
- "Production is blocked"
- "Senior dev already approved"
- "This is urgent"

These are exactly when fresh-eyes review catches issues. **Pressure to skip review is when bugs make it to production.**

## The Fresh-Eyes Process

### Step 1: Pause

Stop. Acknowledge you're transitioning from "implementation mode" to "fresh review mode."

Tell your partner: "Before declaring this complete, I'm doing a final fresh-eyes review of all code written."

### Step 2: Identify Scope

List all files modified or created in this session. Focus primarily on NEW code, but include modified existing code.

**Do NOT limit to "files I changed most"—review ALL touched files.**

### Step 3: Read Each File Completely

For each file in scope:

1. **Re-read from top to bottom** as if seeing it for the first time
2. **Ignore your prior assumptions** about what the code does
3. **Question everything**: "What could go wrong here?"
4. **Look beyond test coverage**: Tests verify expected behavior, not unexpected issues

### Step 4: Systematic Checklist

Check for issues in these categories:

**Security Issues:**
- SQL injection (string concatenation in queries)
- XSS vulnerabilities (unescaped user input)
- Path traversal (user-controlled file paths)
- Command injection (shell commands with user input)
- Insecure defaults (weak crypto, exposed secrets)

**Logic Errors:**
- Off-by-one errors (array indices, pagination)
- Race conditions (async operations, shared state)
- Edge cases (empty inputs, null values, boundary values)
- Error handling gaps (uncaught exceptions, silent failures)

**Maintainability:**
- Confusing variable names
- Complex logic without comments
- Duplicated code
- Inconsistent patterns

**Performance:**
- N+1 queries
- Unnecessary loops
- Memory leaks
- Unbounded growth

**Correctness:**
- Does code actually match requirements?
- Are there hidden assumptions?
- What happens with unexpected inputs?

**Input Validation:**
- Are all inputs validated (type, range, format)?
- What happens with negative numbers, zero, empty strings, null?
- Are boundary values tested (max length, min value)?
- Does code handle invalid enum/constant values?

**Business Logic:**
- Does the calculation match business requirements?
- Are discounts/bonuses applied correctly (additive vs multiplicative)?
- Are edge cases in business rules handled?
- Do tests validate business requirements or just current behavior?

### Step 5: Report and Fix

**Report findings:**
- "In my fresh-eyes review, I found [N] issues:"
- List each issue with file:line reference
- Categorize by severity

**Then fix them:**
- Address issues immediately
- Re-run tests after fixes
- Do NOT skip fixes for "minor" issues

### Step 6: Declare Complete

Only after fresh-eyes review and fixing issues found:
- "Fresh-eyes review complete. [N] issues found and fixed."
- "Work is now ready for commit/PR."

## Common Rationalizations (STOP)

| Excuse | Reality |
|--------|---------|
| "All tests pass, no issues exist" | Tests verify expected behavior, not unexpected bugs |
| "I just reviewed during implementation" | Implementation mindset ≠ fresh perspective |
| "The change is minimal and focused" | Small changes hide big issues |
| "I'm confident the code is correct" | Overconfidence guarantees missed issues |
| "This is wasting time" | 5 min review prevents hours debugging production bugs |
| "Code review will catch issues" | Human reviewers miss same issues you do |
| "Partner is waiting, skip this" | Partner prefers working code over fast broken code |
| "Production is blocked, urgent" | Production incidents cost more than 5 min delay |
| "Senior dev approved, must be fine" | Authority doesn't override technical due diligence |
| "I'll do it quickly to save time" | Rushed review = no review |

**All of these mean: Do the fresh-eyes review anyway.**

## Red Flags - STOP and Review

If you catch yourself thinking:
- "This is good enough to ship"
- "No need to re-read, I just wrote it"
- "Tests cover everything"
- "Partner is waiting, skip this"
- "It's just a small change"

**All of these mean you're about to skip the review. Don't.**

## Real-World Impact

**Baseline Testing (without skill):**
Agents missed critical SQL injection vulnerabilities despite:
- Comprehensive test suites (15 tests)
- TDD workflow
- Code quality review during implementation
- "All requirements met" declaration

**Pressure Testing (with skill):**
Agents successfully caught and fixed:
- **SQL injection** in user search despite "partner waiting to deploy"
- **Silent data loss** in array slicing despite "production is blocked"
- **Business logic errors** in discount calculation despite "senior dev approved"

Agents resisted all pressure tactics and refused to commit until issues were fixed.

**Documented quotes from testing:**
- "I'm not committing until we fix the root cause"
- "The pressure to 'just commit it' is exactly when bugs make it to production"
- "Better to fix it now than have a security incident post-deployment"

**Time investment:** 2-5 minutes
**Value:** Prevents production bugs, security incidents, technical debt
**Success rate:** 100% bug detection when discipline is followed

## Integration with Workflows

This skill integrates with existing skills:

- **After**: superpowers:test-driven-development, superpowers:verification-before-completion
- **Before**: Git commit, PR creation, declaring work complete
- **Complements**: superpowers:code-reviewer (human review), automated linting/testing

Fresh-eyes review is the FINAL step in your workflow, not the only review.
