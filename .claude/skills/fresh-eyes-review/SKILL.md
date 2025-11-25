---
name: fresh-eyes-review
description: Use before git commit, before PR creation, before declaring done - mandatory final sanity check after tests pass; catches SQL injection, security vulnerabilities, edge cases, and business logic errors that slip through despite passing tests; the last line of defense before code ships
---

# Fresh-Eyes Review

## TL;DR

1. **ANNOUNCE** - "Starting fresh-eyes review of [N] files. 2-5 minutes."
2. **RE-READ ALL CODE** - Every file you touched, top to bottom
3. **RUN THE CHECKLIST** - Security, logic, edge cases, business rules
4. **FIX EVERYTHING** - No "minor issues" exceptions
5. **DECLARE** - "Fresh-eyes complete. [N] issues found and fixed." (even if 0)
6. **THEN COMMIT** - Only after declaration

**If you're about to commit without announcing findings, STOP.**

**Violating the letter of this process is violating the spirit of this process.**

## The Iron Law

```
NO COMMIT WITHOUT FRESH-EYES REVIEW FIRST
```

Tests pass? Great. Code reviewed? Great. You're still not done until fresh-eyes review is complete.

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

## What Fresh-Eyes Catches That Tests Don't

Tests verify *expected* behavior. Fresh-eyes catches *unexpected* issues.

| Category | Tests Check | Fresh-Eyes Catches |
|----------|-------------|-------------------|
| **Security** | "Valid input returns valid output" | SQL injection in string concatenation nobody tested |
| **Logic** | "Function returns correct result" | Off-by-one error in edge case nobody wrote test for |
| **Business** | "Discount applies correctly" | Discount stacks wrong when combined with promotion |
| **Performance** | "Function completes" | N+1 query that works but kills production |
| **Edge Cases** | Cases you thought of | Cases you didn't think of |

**Concrete examples from real sessions:**

```
TEST PASSED: "User search returns matching users"
FRESH-EYES FOUND: Query uses string concatenation → SQL injection

TEST PASSED: "Pagination returns correct page"
FRESH-EYES FOUND: Off-by-one error on last page with partial results

TEST PASSED: "Discount calculation is correct"
FRESH-EYES FOUND: 20% discount + 10% promo = 28% not 30% (multiplicative vs additive)

TEST PASSED: "File upload saves correctly"
FRESH-EYES FOUND: User-controlled filename → path traversal vulnerability

SCENARIO PASSED: "End-to-end checkout flow works"
FRESH-EYES FOUND: Silent data truncation on long addresses
```

**Key insight:** You can have 100% test coverage and passing scenarios and STILL have critical bugs. Tests verify what you thought to test. Fresh-eyes finds what you didn't think to test.

## Relationship to Scenario Testing

**Scenario testing and fresh-eyes review are DIFFERENT checks. Both are required.**

| Check | What It Validates | What It Misses |
|-------|-------------------|----------------|
| **Scenario Testing** | System works end-to-end with real data | Code quality, security patterns, edge cases not in scenario |
| **Fresh-Eyes Review** | Code quality, security, logic, edge cases | Whether system actually works (that's what scenarios do) |

**The workflow:**
```
Implementation → Unit Tests (human comfort) → Scenario (validation) → Fresh-Eyes → Commit
```

**Common mistake:** "Scenario passed, so I'm done."

**Reality:** Scenario proves the happy path works. Fresh-eyes catches the security hole in how you implemented it.

**Both must pass. Neither replaces the other.**

## The Fresh-Eyes Process

### Step 1: Announce and Commit

**You MUST say this out loud to your partner:**

> "Before committing, I'm starting fresh-eyes review of [N] files. This will take 2-5 minutes."

This is a **commitment device**. By announcing it, you've committed to doing it. Skipping now would mean breaking your word.

**Why announce?**
- Creates accountability
- Sets time expectations with partner
- Transitions your mindset from "implementation" to "review"
- Partner knows not to rush you

**Do NOT skip the announcement.** The announcement IS part of the process.

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

### Step 6: Declare Complete (MANDATORY)

**You MUST announce your findings, even if you found nothing.**

If issues found:
> "Fresh-eyes review complete. Found [N] issues: [list them]. All fixed. Ready to commit."

If no issues found:
> "Fresh-eyes review complete. 0 issues found. Ready to commit."

**Why announce even zero issues?**
- Proves you actually did the review (not just skipped it)
- Creates a record that the review happened
- Forces you to commit to "I reviewed everything and found nothing"
- If you can't say "0 issues found" confidently, you didn't finish the review

**Do NOT commit without this declaration.** The declaration IS the gate.

## Time-Boxing

**Fresh-eyes review takes 2-5 minutes. Not longer. Not shorter.**

| Files Changed | Expected Time |
|---------------|---------------|
| 1-3 files | 2 minutes |
| 4-7 files | 3-4 minutes |
| 8+ files | 5 minutes |

**If it's taking longer than 5 minutes:**
- You're finding lots of issues → Good, fix them, but something went wrong earlier
- You're being too thorough → Focus on the checklist, not perfection
- The change was too big → Next time, break it into smaller commits

**If it's taking less than 2 minutes:**
- You're skimming, not reviewing → Slow down
- You skipped files → Go back
- You didn't run the checklist → Run it

**Set expectations with your partner:** "This will take 2-5 minutes." Then deliver.

## Quick Reference

| Check Category | What to Look For |
|----------------|------------------|
| **Security** | SQL injection, XSS, path traversal, command injection, exposed secrets |
| **Logic** | Off-by-one, race conditions, null handling, error gaps |
| **Edge Cases** | Empty inputs, zero, negative numbers, boundary values |
| **Business Logic** | Requirements match? Calculations correct? Rules complete? |
| **Performance** | N+1 queries, unbounded loops, memory leaks |
| **Input Validation** | Type checks, range checks, format validation |

## Definition of Done (Fresh-Eyes Review)

**The fresh-eyes review is complete when ALL of these are true:**

- [ ] **ANNOUNCED** start: "Starting fresh-eyes review of [N] files. 2-5 minutes."
- [ ] Listed ALL files touched in this session
- [ ] Re-read EACH file top-to-bottom with fresh perspective
- [ ] Checked security issues (SQL injection, XSS, etc.)
- [ ] Checked logic errors (off-by-one, race conditions, edge cases)
- [ ] Checked business logic matches requirements
- [ ] Checked input validation is complete
- [ ] Found issues are FIXED (not just noted)
- [ ] Tests still pass after fixes
- [ ] **DECLARED** completion: "Fresh-eyes review complete. [N] issues found and fixed."
- [ ] Time taken was 2-5 minutes (not less, not excessively more)

**The review is NOT complete if:**
- You didn't announce before starting
- You skipped any files you touched
- You skimmed instead of reading completely
- You found issues but didn't fix them
- You rationalized skipping any checklist item
- You're rushing because "partner is waiting"
- You didn't declare findings (even if 0)
- It took less than 2 minutes (you skimmed)

## Self-Correction Protocol

**If you catch yourself about to commit without fresh-eyes review:**
1. STOP
2. Do NOT run `git commit`
3. Go back to Step 1 of the fresh-eyes process
4. Complete the full review
5. THEN commit

**If you started reviewing but forgot to announce:**
1. STOP
2. Announce now: "Starting fresh-eyes review of [N] files. 2-5 minutes."
3. Start over from the beginning of Step 2
4. The announcement resets your mindset

**If you catch yourself rushing the review:**
1. STOP
2. Acknowledge: "I'm rushing because [reason]"
3. Remember: Rushing is exactly when bugs slip through
4. Slow down and complete properly
5. 5 minutes now saves hours later

**If you found issues but are tempted to "fix them later":**
1. STOP
2. "Fix later" means "ship bugs now"
3. Fix the issues NOW
4. Re-run tests
5. THEN commit

**If partner is pressuring you to skip:**
1. Say: "Before committing, I need to do a fresh-eyes review"
2. This takes 2-5 minutes
3. Partner prefers working code over fast broken code
4. Do not skip

**If you're about to commit without declaring findings:**
1. STOP
2. Did you actually do the review?
3. If yes → Declare: "Fresh-eyes complete. [N] issues found and fixed."
4. If no → Go back to Step 1
5. THEN commit

## When Stuck

| Problem | Solution |
|---------|----------|
| "Don't know what to look for" | Use the systematic checklist in Step 4 |
| "Too many files to review" | Review ALL of them. That's the job. |
| "Partner is pressuring me" | 5 minutes now vs hours debugging later. Don't skip. |
| "I'm confident it's correct" | Overconfidence = missed bugs. Review anyway. |
| "Found issue but unsure how to fix" | **ASK YOUR HUMAN.** Don't ship known bugs. |
| "Tests pass, isn't that enough?" | Tests verify expected behavior, not unexpected bugs. |
| "Change is too small to review" | Small changes hide big issues. Review it. |
| "Already reviewed during implementation" | Implementation mindset ≠ fresh perspective. Review again. |
| "Found something but not sure if it's a real issue" | **ASK YOUR HUMAN.** They'll help you decide. Don't ignore it. |
| "This might be a security issue but I'm not certain" | **ASK YOUR HUMAN.** Security uncertainty = assume it's real. |

**When in doubt, ASK YOUR HUMAN.** They would rather you ask about a non-issue than ship a real bug.

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

## The Bottom Line

```
TESTS PASS + CODE REVIEWED + FRESH-EYES COMPLETE = READY TO COMMIT
TESTS PASS + CODE REVIEWED + NO FRESH-EYES = NOT READY
```

5 minutes of fresh-eyes review prevents hours of debugging in production.

Do the review. Every time. No exceptions.
