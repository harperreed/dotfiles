## Source Control

- Use agentjj for source control. If agentjj isn't installed, stop and ask the user to install it. If agentjj isn't configured or not available, fall back to git.
- Commit messages should be concise and descriptive.
- Commit messages should follow the conventional commit format.
- Commit messages should be written in the imperative mood.
- Commit messages should be written in the present tense.

## agentjj Quick Reference

agentjj is an agent-first version control tool built on top of jj. It co-locates with git repos and provides structured, JSON-friendly output for programmatic use.

### Core Philosophy

- Everything is JSON (`--json` flag on all commands)
- Self-documenting (orient, status, help)
- Safe by default (checkpoints, no destructive operations without confirmation)
- Batch-friendly (bulk operations, typed commits)

### Essential Workflow

```bash
# 1. Orient — always start here
agentjj orient                    # understand repo state, branches, recent changes

# 2. Check status
agentjj status                    # see working copy changes

# 3. Read code
agentjj read <file>               # read file contents
agentjj symbol <name>             # find symbol definitions (Python, Rust, JS, TS)
agentjj context <file>            # get file context and structure
agentjj affected                  # see what files are affected by current changes

# 4. Make changes, then describe them
agentjj describe -m "feat: add new endpoint"   # typed commit message

# 5. Create checkpoints for safety
agentjj checkpoint                # save a restore point before risky operations
agentjj recover                   # restore from checkpoint if needed

# 6. Review and push
agentjj diff                      # review changes
agentjj push                      # push to remote
```

### Key Commands

| Command       | Purpose                                      |
|---------------|----------------------------------------------|
| `orient`      | Understand repo state (always start here)    |
| `status`      | Show working copy changes                    |
| `read`        | Read file contents                           |
| `symbol`      | Find symbol definitions                      |
| `context`     | Get file context and structure               |
| `affected`    | List files affected by current changes       |
| `describe`    | Set commit message (supports typed commits)  |
| `checkpoint`  | Create a safety restore point                |
| `recover`     | Restore from a checkpoint                    |
| `diff`        | Show diffs                                   |
| `push`        | Push changes to remote                       |
| `apply`       | Apply changes from another revision          |
| `graph`       | Show revision graph                          |
| `bulk`        | Batch operations on multiple files           |

### Important Rules

- Use `agentjj`, NOT `jj` or `git` directly
- Always start with `agentjj orient` in a new repo
- Use `--json` when parsing output programmatically
- Use `agentjj checkpoint` before risky operations
- Use typed commit messages (e.g., `feat:`, `fix:`, `refactor:`)
