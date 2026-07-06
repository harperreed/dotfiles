---
name: uv
description: uv workflows for Python — dependencies, virtualenvs, PEP 723 scripts, Python version management, CI, and Docker. Use when working on Python packaging/deps/tooling, writing GitHub Actions for Python projects, or building Docker images for Python apps.
---

# uv Field Manual

Assumption: `uv` is installed and on PATH (`uv --version` to confirm; if missing, halt and report).
Version pins below were current 2026-07-05 — verify before relying on them.

## Daily workflows

### Project ("cargo-style") flow

```bash
uv init myproj                     # create pyproject.toml + .venv
cd myproj
uv add ruff pytest httpx           # fast resolver + lock update
uv run pytest -q                   # run tests in project venv
uv lock                            # refresh uv.lock (if needed)
uv sync --locked                   # reproducible install (CI-safe)
```

### Script flow (PEP 723)

```bash
uv run hello.py                    # zero-dep script, auto-env
uv add --script hello.py rich      # embeds dep metadata in the script
uv run --with rich hello.py        # transient deps, no state
```

### CLI tools (pipx replacement)

```bash
uvx ruff check .                   # ephemeral run
uv tool install ruff               # user-wide persistent install
uv tool list                       # audit installed CLIs
uv tool update --all               # keep them fresh
```

### Python version management

```bash
uv python install 3.12 3.13
uv python pin 3.13                 # writes .python-version
uv run --python 3.12 script.py
```

### Legacy pip interface

```bash
uv venv .venv
source .venv/bin/activate
uv pip install -r requirements.txt
uv pip sync   -r requirements.txt   # deterministic install
```

## Performance knobs

| Env Var                   | Purpose                 | Typical value |
| ------------------------- | ----------------------- | ------------- |
| `UV_CONCURRENT_DOWNLOADS` | saturate fat pipes      | `16` or `32`  |
| `UV_CONCURRENT_INSTALLS`  | parallel wheel installs | CPU cores     |
| `UV_OFFLINE`              | cache-only mode         | `1`           |
| `UV_INDEX_URL`            | internal mirror         | `https://…`   |
| `UV_PYTHON`               | pin interpreter in CI   | `3.13`        |

```bash
uv cache dir && uv cache size      # show path + size
uv cache clean                     # wipe wheels & sources
```

## CI: GitHub Actions

```yaml
name: tests
on: [push]
jobs:
  pytest:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v8.2.0   # immutable releases since v8.0.0 — moving tags like @v8 do NOT exist; pin the full version
      - run: uv python install            # obeys .python-version
      - run: uv sync --locked
      - run: uv run pytest -q
```

## Docker (multistage — the one true recipe)

```dockerfile
# Build stage
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder
WORKDIR /app
# Deps first for layer caching; code after
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-cache --no-dev

# Runtime stage
FROM debian:bookworm-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
RUN useradd --create-home --shell /bin/bash app
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY --chown=app:app . .
USER app
ENV PATH="/app/.venv/bin:$PATH"
CMD ["uv", "run", "python", "-m", "myapp"]
```

Tips: copy `pyproject.toml` + `uv.lock` before app code (layer caching); `--frozen` honors the lockfile exactly; `--no-cache` keeps the image lean; `--no-dev` skips dev deps; set `PATH` so the venv is active.

## Migration matrix

| Legacy               | Replacement            |
| -------------------- | ---------------------- |
| `python -m venv`     | `uv venv`              |
| `pip install`        | `uv pip install`       |
| `pip-tools compile`  | `uv lock`              |
| `pipx run`           | `uvx`                  |
| `poetry add`         | `uv add`               |
| `pyenv install`      | `uv python install`    |

## Troubleshooting

| Symptom                  | Resolution                                             |
| ------------------------ | ------------------------------------------------------ |
| `Python X.Y not found`   | `uv python install X.Y` or set `UV_PYTHON`             |
| C-extension build errors | `unset UV_NO_BUILD_ISOLATION`                          |
| Need a fresh env         | `uv cache clean && rm -rf .venv && uv sync`            |
| Still stuck              | `RUST_LOG=debug uv ...`                                |
