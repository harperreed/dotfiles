---
name: scenario-testing
description: Use when writing tests or validating features - enforces scenario-driven end-to-end testing instead of unit tests for codegen agents
---

# Scenario-Driven Testing for AI Code Generation

**When to use this skill:**
- Any time you need to validate that code works
- When user asks to "test" or "verify" a feature
- After implementing new functionality
- When fixing bugs that need validation
- Before declaring work complete

**CRITICAL: You are NOT allowed to write unit tests. Use scenarios instead.**

## The Problem with Unit Tests for AI Agents

Unit tests are designed for humans who make small implementation errors. As an AI agent, your failure mode is different:
- You make **conceptual** mistakes, not typos
- You misunderstand **requirements**, not syntax
- You fail at **integration**, not isolated functions

Unit tests create noise and slow iteration without catching your actual failure modes.

## The Scenario-Driven Alternative

Instead of testing units, validate the **entire system** works from the outside, exactly as users will interact with it.

## Mandatory Protocol

### 1. NEVER Generate Unit Tests

Do not create:
- `*_test.go` files with unit tests
- `test_*.py` files with pytest unit tests
- Isolated function tests
- Mock-based tests

These are forbidden. If you catch yourself doing this, STOP.

### 2. ALWAYS Use End-to-End Scenarios

When you need to validate behavior:

**Write a proof program in `.scratch/`:**

```bash
# Create executable scenario
cat > .scratch/test_feature_name.sh <<'EOF'
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
EOF

chmod +x .scratch/test_feature_name.sh
./.scratch/test_feature_name.sh
```

**Key principles:**
- Use the **actual CLI/API** (no test doubles)
- Create **real data** (no mocks)
- Verify **observable outcomes** (what users see)
- Test the **whole flow** (not isolated pieces)

### 3. Ensure `.scratch/` is Gitignored

Proof programs are temporary. They prove the code works NOW, not forever.

Add to `.gitignore`:
```
.scratch/
```

Never commit `.scratch/` files. They're disposable.

### 4. Promote Recurring Scenarios to `scenarios.jsonl`

When the same validation pattern appears multiple times, extract it:

```jsonl
{"name":"feature_x_basic","description":"Feature X handles basic case","given":"Starting state","when":"User action","then":"Expected outcome","validates":["behavior_1","behavior_2"]}
```

**Format:**
- One scenario per line (JSONL, not JSON)
- Include: name, description, given/when/then, validates
- Document the **behavior contract**, not the implementation

This file becomes the **canonical spec** for what the system must do.

### 5. Design for External Verification

Assume your code will be tested by an external scenario runner that:
- Only has access to public APIs/CLI
- Cannot see internal implementation
- Expects clear, human-readable error messages

Write code that can be **driven from outside** with **observable failures**.

## Examples

### ❌ WRONG: Unit Test

```python
# tests/test_calculator.py - FORBIDDEN
def test_add():
    calc = Calculator()
    assert calc.add(2, 3) == 5
```

**Why wrong:**
- Tests implementation detail
- Doesn't validate user experience
- Misses integration failures

### ✅ RIGHT: End-to-End Scenario

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

### ❌ WRONG: Mock-Based Test

```go
// handlers_test.go - FORBIDDEN
func TestGetContact(t *testing.T) {
    mockDB := &MockDB{
        contacts: []Contact{{Name: "John"}},
    }
    handler := NewHandler(mockDB)
    // ...
}
```

**Why wrong:**
- Tests against fake database
- Won't catch SQL errors
- Won't catch serialization bugs
- Doesn't prove real system works

### ✅ RIGHT: Real Database Scenario

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

## Common Rationalizations to Reject

If you catch yourself thinking:
- "Just a quick unit test to verify..." → STOP. Write scenario.
- "This is too simple for end-to-end..." → STOP. Write scenario.
- "Unit tests are faster..." → WRONG. They don't catch your bugs.
- "This helper function needs testing..." → NO. Test the feature that uses it.
- "I'll mock the database for speed..." → NO. Use real database.

**Why:** Your bugs are conceptual. Only end-to-end scenarios catch them.

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
- [ ] Does it use REAL data stores (not mocks)?
- [ ] Does it use the actual CLI/API?
- [ ] Is `.scratch/` in `.gitignore`?
- [ ] Did you run the scenario and see it pass?
- [ ] If this pattern recurs, did you add to `scenarios.jsonl`?

If you answered "no" to any: you're not done.

## Summary

**Traditional approach (FORBIDDEN):**
```
Write code → Write unit tests → Run test suite → Ship
```

**Scenario-driven approach (REQUIRED):**
```
Write code → Write .scratch/ proof program → Run end-to-end → Extract to scenarios.jsonl if recurring → Ship
```

The difference: You validate that the **system works as users experience it**, not that isolated functions behave correctly.

---

**Remember:** As an AI agent, you make big conceptual mistakes, not small typos. Only end-to-end scenarios catch your failure mode.
