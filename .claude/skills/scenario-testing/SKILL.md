---
name: scenario-testing
description: Use when writing tests, validating features, or tempted to use mocks - enforces scenario-driven end-to-end testing with real dependencies; mocks are lies that hide bugs; scenarios with real data are the only source of truth for AI agents
---

# Scenario-Driven Testing for AI Code Generation

**When to use this skill:**
- Any time you need to validate that code works
- When user asks to "test" or "verify" a feature
- After implementing new functionality
- When fixing bugs that need validation
- Before declaring work complete
- **When tempted to mock a dependency**

## TL;DR

1. **Write scenario in `.scratch/`** - any language, exercises real system
2. **NO MOCKS** - real database, real APIs, real filesystem
3. **Run it** - must pass with real dependencies
4. **Never commit `.scratch/`** - ensure it's in `.gitignore`
5. **Unit tests are optional** - human comfort only, not validation

**If you used mocks, your scenario is invalid. Start over.**

**Violating the letter of these rules is violating the spirit of these rules.**

## The Iron Law

```
NO FEATURE IS VALIDATED UNTIL A SCENARIO PASSES WITH REAL DEPENDENCIES
```

Unit tests may exist. Mocks may exist in unit tests. But the feature is NOT validated until a scenario proves it works end-to-end with real data and real systems.

**CRITICAL: Scenarios are GOD. Unit tests are comfort blankets for humans. Mocks are lies.**

## The Hierarchy of Truth

```
SCENARIO TESTS (real system, real data)     ← TRUTH. This is what matters.
         ↑
         │ validates
         │
    UNIT TESTS (isolated, fast)             ← Comfort. For humans who want coverage numbers.
```

**A feature is NOT validated until a scenario proves it works end-to-end with real data.**

Unit tests may exist. Humans like them. They provide warm feelings and green checkmarks. But they prove NOTHING about whether the system actually works.

## The Problem with Unit Tests for AI Agents

Unit tests are designed for humans who make small implementation errors. As an AI agent, your failure mode is different:
- You make **conceptual** mistakes, not typos
- You misunderstand **requirements**, not syntax
- You fail at **integration**, not isolated functions

Unit tests won't catch your bugs. Only scenarios will.

## The Problem with Mocks

**MOCKS ARE LIES.**

A test that uses mocks is not testing your system. It's testing your assumptions about how dependencies behave. When a scenario "passes" with mocks, it didn't pass—it was **faked**.

Consider:
- Mock database returns what you expect → Real database throws constraint violation
- Mock API returns success → Real API rate limits you
- Mock filesystem works → Real filesystem has permission errors

**If you mock it, you didn't test it.** You tested a fantasy. And fantasies don't run in production.

**Need real integrations?** Ask your human partner. They will happily provide API keys, test databases, staging environments, or whatever you need to test against real systems. Don't mock because you're missing credentials—ask for the real thing.

### External/Third-Party APIs

For APIs you don't control (Stripe, Twilio, AWS, etc.):

- **Unit tests:** May use mocks for speed and isolation. That's fine—they're just human comfort anyway.
- **Scenarios:** MUST hit the real API. Use sandbox/test mode if available (Stripe test keys, Twilio test credentials, etc.).
- **The rule:** A scenario is NOT passing until it interacts with the external API—test mode or production. Mocked API calls mean the scenario didn't run.

```
Unit test with mock Stripe API    → Fine. Human comfort.
Scenario with mock Stripe API     → NOT A PASSING SCENARIO. It's a lie.
Scenario with Stripe test mode    → VALID. Real API, test environment.
Scenario with Stripe production   → VALID. Real API, real money (be careful).
```

## The Scenario-Driven Approach

Validate the **entire system** works from the outside, exactly as users will interact with it. No mocks. No fakes. No fantasies.

## Mandatory Protocol

### 1. Scenarios Are The Only Source of Truth

Unit tests may exist for human comfort, but they do NOT validate that a feature works.

You may write unit tests if:
- The project already has them and humans expect them
- A human specifically requests them
- You want to document edge cases for future humans

But understand: **unit tests are a courtesy, not validation.**

### 2. ALWAYS Use End-to-End Scenarios for Validation

When you need to validate behavior:

**Write a proof program in `.scratch/`:**

Use whatever language makes sense for the task. Bash, Python, Go, Node—doesn't matter. What matters is that it:
1. Exercises the REAL system
2. Uses REAL data
3. Has NO mocks

```bash
# Example: Bash scenario
.scratch/test_feature_name.sh

#!/bin/bash
set -e

echo "=== Testing Feature X ==="

# Setup test data
./app setup-test-data

# Exercise the ENTIRE system from outside
./app command --flag value

# Verify observable behavior
./app query | grep "expected result"

echo "✓ Feature X works end-to-end"
```

```python
# Example: Python scenario
# .scratch/test_feature_name.py

import subprocess
import sys

print("=== Testing Feature X ===")

# Exercise the REAL system
result = subprocess.run(["./app", "command", "--flag", "value"], capture_output=True, text=True)
assert result.returncode == 0, f"Command failed: {result.stderr}"

# Verify observable behavior
query_result = subprocess.run(["./app", "query"], capture_output=True, text=True)
assert "expected result" in query_result.stdout, f"Expected result not found in: {query_result.stdout}"

print("✓ Feature X works end-to-end")
```

**Key principles:**
- Use the **actual CLI/API** (no test doubles)
- Create **real data** (NO MOCKS, EVER)
- Verify **observable outcomes** (what users see)
- Test the **whole flow** (not isolated pieces)
- **Language is your choice**—use what fits the project

### 3. NEVER Commit `.scratch/`

Proof programs are temporary. They prove the code works NOW, not forever.

**`.scratch/` must NEVER be committed to git. EVER.**

Before writing any scenario, verify `.scratch/` is in `.gitignore`:
```bash
grep -q "\.scratch" .gitignore || echo ".scratch/" >> .gitignore
```

If `.gitignore` doesn't exist, create it:
```bash
echo ".scratch/" > .gitignore
```

**Why?** Scenarios are proof-of-the-moment. They validate your current work. They're not permanent test infrastructure—they're disposable validation tools. Commit the code, not the proof that you tested it.

### 4. Promote Recurring Scenarios to `scenarios.jsonl`

When a pattern becomes robust or a test is particularly good, extract it to `scenarios.jsonl`:

**Promote when:**
- A pattern appears across multiple features (e.g., "every action requires a logged-in user")
- The scenario captures critical business logic that must never break
- You've written a really good test that documents important behavior
- The scenario would help future developers understand the system

```jsonl
{"name":"feature_x_basic","description":"Feature X handles basic case","given":"Starting state","when":"User action","then":"Expected outcome","validates":["behavior_1","behavior_2"]}
```

**Format:**
- One scenario per line (JSONL, not JSON)
- Include: name, description, given/when/then, validates
- Document the **behavior contract**, not the implementation

This file becomes the **canonical spec** for what the system must do. Unlike `.scratch/`, this file IS committed—it's documentation of system behavior.

### 5. Design for External Verification

Assume your code will be tested by an external scenario runner that:
- Only has access to public APIs/CLI
- Cannot see internal implementation
- Expects clear, human-readable error messages

Write code that can be **driven from outside** with **observable failures**.

## Examples

### 🤷 ACCEPTABLE: Unit Test (Human Comfort)

```python
# tests/test_calculator.py - Fine, but proves nothing
def test_add():
    calc = Calculator()
    assert calc.add(2, 3) == 5
```

**Why it's just okay:**
- Humans like coverage numbers
- Documents expected behavior for future readers
- Fast feedback during development
- **BUT: Does not validate the feature works in the real system**

You can write this. It makes humans happy. But don't fool yourself into thinking the feature is validated.

### ✅ TRUTH: End-to-End Scenario

```bash
# .scratch/test_calculation_workflow.sh
#!/bin/bash
set -e

echo "=== Calculator End-to-End Scenario ==="

# Use actual CLI
./calc add 2 3 > result.txt

# Verify observable output
if grep -q "Result: 5" result.txt; then
    echo "✓ Addition works correctly"
else
    echo "✗ Addition failed"
    cat result.txt
    exit 1
fi

# Test with real data file
echo "2 + 3" > input.txt
./calc --batch input.txt | grep "Result: 5"

echo "✓ Batch mode works"

rm result.txt input.txt
```

**Why right:**
- Uses actual program interface
- Tests real file I/O
- Validates end-user experience
- Would catch integration bugs

### ☠️ FORBIDDEN: Mock-Based Test

```go
// handlers_test.go - THIS IS A LIE
func TestGetContact(t *testing.T) {
    mockDB := &MockDB{
        contacts: []Contact{{Name: "John"}},
    }
    handler := NewHandler(mockDB)
    // ...
}
```

**Why this is WORSE than no test at all:**
- It LIES to you. It says "passing" when nothing was tested.
- Tests against a fantasy database that does what you expect
- Won't catch SQL errors, constraint violations, connection issues
- Won't catch serialization bugs, encoding problems, data type mismatches
- Creates FALSE CONFIDENCE that the system works
- **Production will teach you the truth. Painfully.**

A mock test is not a test. It's a simulation of a test. It's you playing pretend.

**If your scenario uses mocks, it did not pass. It faked passing.**

### ✅ TRUTH: Real Database Scenario

```bash
# .scratch/test_contact_retrieval.sh
#!/bin/bash
set -e

echo "=== Contact Retrieval Scenario ==="

# Use temporary REAL database
export DB=/tmp/test_$$.db

# Setup through actual CLI
./crm --db-path $DB crm add-contact \
    --name "John Smith" \
    --email "john@example.com"

# Retrieve through actual CLI
RESULT=$(./crm --db-path $DB crm list-contacts --query "John")

# Verify observable JSON output
echo "$RESULT" | jq -e '.[] | select(.name == "John Smith")'
echo "$RESULT" | jq -e '.[] | select(.email == "john@example.com")'

echo "✓ Contact creation and retrieval works"

rm $DB
```

**Why right:**
- Real SQLite database
- Real JSON serialization
- Real CLI argument parsing
- Catches actual failure modes

## Scenario Structure

Good scenarios follow this pattern:

```bash
#!/bin/bash
set -e  # Fail fast on errors

echo "=== Scenario: What This Tests ==="

# 1. SETUP: Create necessary state
#    - Use real data stores
#    - Use actual APIs/CLI
echo "Setting up test data..."
./app create-resource --real-flag

# 2. EXERCISE: Perform the actual operation
echo "Exercising feature..."
RESULT=$(./app the-feature --param value)

# 3. VERIFY: Check observable outcomes
echo "Verifying results..."
echo "$RESULT" | grep "expected value" || {
    echo "✗ Feature failed"
    echo "Got: $RESULT"
    exit 1
}

# 4. CLEANUP: Remove test artifacts
echo "Cleaning up..."
rm -f /tmp/test_*

echo "✓ Scenario passed"
```

## Flaky Scenarios Are Bugs

If a scenario passes sometimes and fails other times, **that is not a flaky test—that is a bug.**

Do NOT:
- Retry until it passes
- Mark it as "flaky" and ignore
- Add sleep statements and hope for the best
- Blame "test infrastructure"

DO:
- Investigate immediately
- Find the race condition, timing issue, or state pollution
- Fix the underlying code
- A scenario that can't pass reliably indicates unreliable code

**Flakiness is a smell.** Something is wrong with the code, not the test. Real systems serving real users can't be flaky—they need to work every time.

## When Scenarios Fail

A failing scenario is a gift. It caught something before production did. Here's the protocol:

1. **Read the failure output carefully.** What exactly failed? What was expected vs actual?

2. **Reproduce locally.** Run the scenario again. Does it fail consistently? (If not, see "Flaky Scenarios Are Bugs" above.)

3. **Audit the code path.** Trace through the code the scenario exercises. Where did reality diverge from expectation?

4. **Use unit tests as diagnostic tools.** This is where unit tests become valuable—not for validation, but for triangulation. Write targeted unit tests to isolate which component is misbehaving.

5. **Fix the code, not the scenario.** If the scenario expects correct behavior and the code is wrong, fix the code. Don't weaken the scenario to match broken behavior.

6. **Re-run the scenario.** Only when it passes with real data and real dependencies is the fix complete.

```
Scenario fails
     ↓
Reproduce consistently (if flaky, that's a bug too)
     ↓
Audit code path
     ↓
Use unit tests to triangulate the problem
     ↓
Fix the code
     ↓
Scenario passes with REAL dependencies
     ↓
Done
```

## Scenario Naming Conventions

Good scenario names are discoverable and descriptive. Follow this pattern:

```
test_<feature>_<behavior>_<context>.sh
```

Examples:
- `test_auth_login_with_valid_credentials.sh`
- `test_auth_login_with_expired_token.sh`
- `test_checkout_payment_with_insufficient_funds.sh`
- `test_api_rate_limiting_after_100_requests.sh`
- `test_import_csv_with_unicode_characters.py`

**Rules:**
- Start with `test_`
- Use snake_case
- Feature first, then behavior, then context/edge case
- Be specific enough that you know what it tests without reading it
- Extension matches the language (`.sh`, `.py`, `.go`, etc.)

## Scenario Independence and Sequencing

**Each scenario MUST be independent.** It should be able to run alone, without any other scenario running first.

This means:
- Set up your own test data
- Don't depend on state from previous scenarios
- Clean up after yourself
- Assume the database/system could be empty OR full of garbage

**Why?** Scenarios should run in parallel for speed. Dependencies between scenarios create ordering requirements that slow everything down and create false failures.

### Chained Scenarios (Sequential User Journeys)

Sometimes you want to test a user journey: create account → login → perform action → logout.

This is fine, but implement it as **one scenario that does all steps**, not four dependent scenarios:

```bash
# GOOD: One scenario, complete journey
# .scratch/test_user_complete_journey.sh

#!/bin/bash
set -e

echo "=== User Journey: Signup to Purchase ==="

# Create account
./app signup --email test@example.com --password secret123
echo "✓ Account created"

# Login
TOKEN=$(./app login --email test@example.com --password secret123)
echo "✓ Logged in"

# Perform action
./app --token "$TOKEN" purchase --item SKU123
echo "✓ Purchase completed"

# Cleanup
./app --token "$TOKEN" delete-account --confirm
echo "✓ Journey complete"
```

```bash
# BAD: Four dependent scenarios that must run in order
# .scratch/test_user_1_signup.sh    ← Creates state
# .scratch/test_user_2_login.sh     ← Depends on #1
# .scratch/test_user_3_purchase.sh  ← Depends on #2
# .scratch/test_user_4_cleanup.sh   ← Depends on #3
```

## Timeouts: Think Like a User

Scenarios should complete in a timeframe that a real user would tolerate. If your scenario takes 30 seconds to run, ask yourself: would a user wait 30 seconds for this operation?

**Guidelines:**
- Most scenarios should complete in under 10 seconds
- If a scenario is slow, the feature is slow—that's a problem
- Add explicit timeouts to catch hangs: `timeout 30s ./app command`
- A hanging scenario is a failing scenario

**Remember:** You're testing from the user's perspective. Users don't wait forever. Neither should your scenarios.

## Running Scenarios in Parallel

Scenarios should be designed to run in parallel. This is why independence matters.

```bash
# Run all scenarios in parallel
ls .scratch/test_*.sh | xargs -P 4 -I {} bash -c '{}'

# Or with GNU parallel
parallel --jobs 4 ::: .scratch/test_*.sh
```

If your scenarios can't run in parallel, they're not independent. Fix them.

**Benefits of parallel execution:**
- Faster feedback
- Exposes hidden dependencies between tests
- Proves scenarios are truly independent
- Mimics real-world concurrent usage

## Quick Reference

| Concept | Rule |
|---------|------|
| **Scenarios** | ONLY source of truth. Must use real dependencies. |
| **Unit tests** | Human comfort only. Do NOT validate features. |
| **Mocks in unit tests** | Acceptable for human comfort. |
| **Mocks in scenarios** | FORBIDDEN. Scenario is invalid. |
| **`.scratch/`** | NEVER commit. Always in `.gitignore`. |
| **`scenarios.jsonl`** | Promote robust patterns. IS committed. |
| **Flaky scenarios** | Are bugs. Investigate, don't retry. |
| **External APIs** | Use sandbox/test mode. Still real API. |
| **Missing credentials** | ASK YOUR HUMAN. Don't mock. |
| **Parallel execution** | Default. Scenarios must be independent. |
| **Timeouts** | Think like a user. <10 seconds typical. |

## Red Flags - STOP and Reconsider

If you catch yourself doing or thinking ANY of these, STOP immediately:

- About to add a mock to a scenario
- "I'll mock this for now and test with real data later"
- "The mock will behave the same as the real thing"
- Scenario passes but uses fake data
- "Unit tests pass, so the feature works"
- About to commit `.scratch/`
- Scenario fails sometimes (flaky = bug)
- "I don't have credentials so I'll mock it" (ASK YOUR HUMAN)
- Scenario takes >30 seconds (feature is too slow)
- One scenario depends on another running first
- About to declare feature "done" without running scenario
- "This is too simple for a scenario"

**ALL of these mean: STOP. You're about to lie to yourself.**

### Self-Correction Protocol

**If you catch yourself writing a mock in a scenario:**
1. STOP immediately
2. Delete the mock
3. Ask yourself: "What real dependency am I avoiding?"
4. If missing credentials → ASK YOUR HUMAN
5. If service unavailable → use sandbox/test environment
6. If "too hard" → that's the point, real systems are hard
7. Rewrite scenario with real dependency

**If you already wrote a scenario with mocks:**
1. The scenario is INVALID
2. Do NOT claim the feature is validated
3. Rewrite the scenario without mocks
4. Run again with real dependencies
5. ONLY THEN is the feature validated

**If you're about to say "done" or "feature works":**
1. STOP
2. Did a scenario pass? With REAL dependencies?
3. If no → you're not done
4. If yes → proceed

## Definition of Done

**A feature is DONE when ALL of these are true:**

- [ ] Scenario exists in `.scratch/`
- [ ] Scenario uses ZERO mocks (real DB, real APIs, real filesystem)
- [ ] Scenario passes when you run it NOW (not "passed earlier")
- [ ] `.scratch/` is in `.gitignore`
- [ ] If pattern is robust, added to `scenarios.jsonl`

**A feature is NOT done if:**
- Only unit tests pass (unit tests don't validate)
- Scenario uses mocks (that's a fake pass)
- Scenario "passed earlier" but you didn't run it just now
- You "manually tested" but didn't write a scenario
- `.scratch/` might get committed

## Common Rationalizations to Reject

If you catch yourself thinking:
- "Just a quick unit test to verify..." → Fine for human comfort, but you still need a scenario.
- "This is too simple for end-to-end..." → WRONG. Simple things break in integration. Write scenario.
- "Unit tests are faster..." → Speed doesn't matter if they don't catch your bugs.
- "This helper function needs testing..." → Unit test it if you want. Then test the feature that uses it with a scenario.
- "I'll mock the database for speed..." → **ABSOLUTELY NOT.** You just proposed lying to yourself.
- "Mocks let me test edge cases..." → Test edge cases with real systems. Spin up a test database. It's not hard.
- "The CI is too slow with real databases..." → Then fix your CI. Don't fake your tests.
- "Everyone uses mocks..." → Everyone is wrong. Mocks are why production breaks.
- "I don't have credentials for the real API..." → **ASK YOUR HUMAN.** They will provide them. That's not a reason to mock.

**The core truth:** Your bugs are conceptual and integration-related. Unit tests don't catch them. Mocks actively hide them. Only real end-to-end scenarios reveal them.

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't have API credentials | **ASK YOUR HUMAN.** They will provide them. |
| External service is down | Wait for it. Or use their sandbox/test environment. |
| Scenario is slow | Feature is slow. Fix the feature, not the test. |
| Can't make scenario independent | Refactor to set up own test data. Use unique identifiers. |
| Database state is polluted | Each scenario creates AND cleans up its own data. |
| Scenario is flaky | That's a bug in your code. Investigate race conditions. |
| Don't know how to test X | Write how you'd manually verify it. Automate that. |
| Need to test error cases | Create real error conditions. Don't mock errors. |
| CI doesn't have real DB | Set up real test DB in CI. Don't mock in CI. |

## Integration with Other Skills

**Complementary skills:**
- **superpowers:verification-before-completion** - Run scenario BEFORE claiming feature works
- **superpowers:systematic-debugging** - When scenario fails, use systematic debugging to find root cause
- **superpowers:test-driven-development** - Unit tests for human comfort follow TDD; scenarios validate

**Workflow:**
1. Write code (optionally with TDD for unit tests)
2. Write scenario in `.scratch/`
3. Run scenario with REAL dependencies
4. If fails → use systematic-debugging
5. If passes → use verification-before-completion before claiming done

## Integration with Existing Test Tools

If the project has existing test infrastructure:
- **Pytest/Go test frameworks:** Use them to run scenarios, not unit tests
- **CI/CD:** Run `.scratch/` scenarios as smoke tests
- **Test databases:** Use real test instances, not mocks

The tool doesn't matter. The approach does: **validate the whole system from outside**.

## Checklist

Before completing any feature validation:

- [ ] Did you write a proof program in `.scratch/`?
- [ ] Does it test the ENTIRE flow from outside?
- [ ] Does it use REAL data stores? (If you used mocks, START OVER)
- [ ] Does it use the actual CLI/API?
- [ ] Is `.scratch/` in `.gitignore`? (NEVER commit `.scratch/`)
- [ ] Did you run the scenario and see it pass WITH REAL DEPENDENCIES?
- [ ] If this pattern recurs, did you add to `scenarios.jsonl`?

**Mock check:** Go back through your scenario. Did you mock ANYTHING? Database? API? Filesystem? Network? If yes, your scenario is invalid. Rewrite it with real dependencies.

If you answered "no" to any: you're not done.

## Summary

**Traditional approach (Insufficient):**
```
Write code → Write unit tests → Run test suite → Ship
             ↑
             └── Humans feel good. Nothing is actually validated.
```

**Mock-based approach (FORBIDDEN):**
```
Write code → Write mock tests → Tests pass → Ship → Production breaks
                   ↑                              ↑
                   └── LIES ─────────────────────┘
```

**Scenario-driven approach (REQUIRED):**
```
Write code → Write .scratch/ proof program (NO MOCKS) → Run end-to-end with REAL dependencies → Extract to scenarios.jsonl if recurring → Ship
```

The difference: You validate that the **system works as users experience it**, with **real data** and **real dependencies**. Not isolated functions. Not mocked fantasies.

## The Bottom Line

```
SCENARIO WITH REAL DEPENDENCIES = TRUTH
SCENARIO WITH MOCKS = LIE
UNIT TESTS = HUMAN COMFORT
```

Run the scenario. With real data. With real APIs. With real databases.

THEN you can say the feature works.

---

**Remember:**
- As an AI agent, you make big conceptual mistakes, not small typos. Only end-to-end scenarios catch your failure mode.
- Unit tests are for human comfort. Write them if it makes humans happy.
- **Mocks are lies.** A scenario with mocks is not a passing scenario—it's a faked scenario. Production doesn't have mocks. Test like production.
- **When in doubt, ASK YOUR HUMAN** for real credentials, test environments, or help. Don't mock because you're stuck.
