# File Classification Rules

Detailed rules for classifying files into AUTO_EXCLUDE, AUTO_COMMIT, or CONFIRM categories.

## Classification Priority

Files are checked in this order:

1. **AUTO_EXCLUDE** (highest priority - security critical)
2. **AUTO_COMMIT** (safe patterns)
3. **CONFIRM** (default for ambiguous cases)

## AUTO_EXCLUDE Patterns

### Credentials & Secrets

| Pattern | Reason | Action |
|---------|--------|--------|
| `*credentials*` | Contains authentication data | Exclude + warn + add to .gitignore |
| `*secret*` | Contains secret values | Exclude + warn + add to .gitignore |
| `*password*` | Contains passwords | Exclude + warn + add to .gitignore |
| `*.key`, `*.pem` | Private keys | Exclude + warn + add to .gitignore |
| `.env`, `.env.local` | Environment variables | Exclude + add to .gitignore |

### MCP Configuration

| Pattern | Reason | Action |
|---------|--------|--------|
| `.claude.json` | Contains local MCP server paths | Exclude + add to .gitignore |
| `.mcp.json*` | MCP configuration and backups | Exclude + add to .gitignore |

### Personal Settings

| Pattern | Reason | Action |
|---------|--------|--------|
| `settings.json` | Personal tool/IDE settings | Exclude + add to .gitignore |
| `settings.local.json` | Explicitly local settings | Exclude + add to .gitignore |
| `.vscode/settings.json` | Personal VS Code settings | Exclude + add to .gitignore |
| `.idea/workspace.xml` | Personal IntelliJ workspace | Exclude + add to .gitignore |

### Build Artifacts

| Pattern | Reason | Action |
|---------|--------|--------|
| `node_modules/` | Node.js dependencies | Exclude + add to .gitignore |
| `vendor/` | Go/PHP dependencies | Exclude + add to .gitignore |
| `dist/`, `build/` | Build output | Exclude + add to .gitignore |
| `*.log` | Runtime logs | Exclude + add to .gitignore |
| `*.cache` | Cache files | Exclude + add to .gitignore |
| `coverage/` | Test coverage reports | Exclude + add to .gitignore |

### OS-specific

| Pattern | Reason | Action |
|---------|--------|--------|
| `.DS_Store` | macOS folder metadata | Exclude + add to .gitignore |
| `Thumbs.db` | Windows thumbnail cache | Exclude + add to .gitignore |
| `desktop.ini` | Windows folder settings | Exclude + add to .gitignore |

## AUTO_COMMIT Patterns

### Documentation

| Pattern | Reason | Action |
|---------|--------|--------|
| `*.md` | Markdown documentation | Commit (unless in excluded dirs) |
| `docs/**` | Documentation directory | Commit |
| `README.md`, `CLAUDE.md` | Project documentation | Commit |

### Source Code

| Pattern | Reason | Action |
|---------|--------|--------|
| `src/**` | Source code | Commit |
| `internal/**` | Internal packages (Go) | Commit |
| `lib/**` | Library code | Commit |
| `pkg/**` | Package code (Go) | Commit |

### Tests

| Pattern | Reason | Action |
|---------|--------|--------|
| `*_test.go` | Go test files | Commit |
| `*.test.ts`, `*.test.tsx` | TypeScript/React test files | Commit |
| `*.test.js`, `*.test.jsx` | JavaScript/React test files | Commit |
| `*.spec.ts`, `*.spec.js` | Test spec files | Commit |
| `__tests__/**` | Jest test directory | Commit |

### Configuration (Shareable)

| Pattern | Reason | Action |
|---------|--------|--------|
| `.gitignore` | Version control config | Commit |
| `.editorconfig` | Editor configuration | Commit |
| `.prettierrc*` | Prettier configuration | Commit |
| `package.json` | Node.js manifest | Commit |
| `tsconfig.json` | TypeScript configuration | Commit |
| `go.mod`, `go.sum` | Go modules | Commit |
| `Cargo.toml`, `Cargo.lock` | Rust dependencies | Commit |
| `Makefile` | Build configuration | Commit |

### CI/CD

| Pattern | Reason | Action |
|---------|--------|--------|
| `.github/workflows/**` | GitHub Actions | Commit |
| `.gitlab-ci.yml` | GitLab CI | Commit |
| `Dockerfile` | Container configuration | Commit |
| `docker-compose.yml` | Docker Compose | Commit |

### Skills & Knowledge (~/.claude context)

| Pattern | Reason | Action |
|---------|--------|--------|
| `~/.claude/skills/**` | Personal/Project Skills | Commit |
| `~/.claude/knowledge/**` | Knowledge base | Commit |
| `~/.claude/CLAUDE.md` | Global configuration | Commit |

## CONFIRM Patterns

These require user decision.

### Large Files

| Condition | Action |
|-----------|--------|
| File size > 1MB | Show size, ask if intentional, suggest Git LFS |
| File size > 10MB | Strongly warn, suggest Git LFS or exclusion |

### New Directories

| Condition | Action |
|-----------|--------|
| New directory appears | Show first-level contents, ask about purpose |
| Directory name unclear | Ask user to explain purpose |

### Executable Files

| Pattern | Condition | Action |
|---------|-----------|--------|
| `*.exe`, `*.bin` | No matching source code | Ask if build artifact or tool |
| `*.app`, `*.dmg` | macOS applications | Ask if distribution artifact |
| `*.dll`, `*.so`, `*.dylib` | Shared libraries | Ask if build artifact |

### Configuration Files (Ambiguous)

| Pattern | Condition | Action |
|---------|-----------|--------|
| `*.json` | Not in AUTO lists | Check for local paths, ask user |
| `*.yaml`, `*.yml` | Not in AUTO lists | Check for secrets, ask user |
| `*.toml` | Not in AUTO lists (except `Cargo.toml`) | Ask user |
| `*.ini` | Not OS-specific | Ask user |

### Data Files

| Pattern | Condition | Action |
|---------|-----------|--------|
| `*.db`, `*.sqlite` | Database files | Ask if test fixture or production data |
| `*.csv`, `*.json` | Data files > 100KB | Ask if test data or production data |

## Special Cases

### ~/.claude Repository

When working in `~/.claude`:

- `.gitignore` → AUTO_COMMIT
- `CLAUDE.md` → AUTO_COMMIT
- `skills/**` → AUTO_COMMIT
- `knowledge/**` → AUTO_COMMIT
- `.claude.json` → AUTO_EXCLUDE
- `.mcp.json*` → AUTO_EXCLUDE
- `settings.json` → AUTO_EXCLUDE
- `history.jsonl` → AUTO_EXCLUDE (already in .gitignore)

### Project Repository

- `CLAUDE.md` → AUTO_COMMIT
- `.claude/commands/**` → AUTO_COMMIT
- `.claude/hooks.json` → AUTO_COMMIT
- `.claude/settings.local.json` → AUTO_EXCLUDE

## Classification Algorithm

```
function classifyFile(filename):
    # Priority 1: Check AUTO_EXCLUDE patterns
    if matches_any(AUTO_EXCLUDE_PATTERNS):
        return AUTO_EXCLUDE

    # Priority 2: Check AUTO_COMMIT patterns
    if matches_any(AUTO_COMMIT_PATTERNS):
        return AUTO_COMMIT

    # Priority 3: Check special conditions
    if file_size > 1MB:
        return CONFIRM

    if is_executable(filename):
        return CONFIRM

    if is_new_directory(filename):
        return CONFIRM

    # Default: Confirm with user
    return CONFIRM
```

## Pattern Matching Rules

- `*` matches any characters except `/`
- `**` matches any characters including `/`
- `?` matches single character
- `[abc]` matches any character in brackets
- Use case-insensitive matching for safety

## Examples

### Example 1: .env file

- Pattern match: `.env`
- Category: AUTO_EXCLUDE
- Action: Exclude, ensure in .gitignore, warn user
- Reason: May contain API keys or database credentials

### Example 2: README.md

- Pattern match: `*.md`
- Category: AUTO_COMMIT
- Action: Commit
- Reason: Documentation is shareable

### Example 3: config.json (new file)

- Pattern match: `*.json` (not in specific lists)
- Category: CONFIRM
- Action: Ask user if it contains local paths or secrets
- Reason: Could be shareable config or personal settings

### Example 4: dist/app.js (2.5MB)

- Pattern match: `dist/`
- Category: AUTO_EXCLUDE
- Action: Exclude, ensure `dist/` in .gitignore
- Reason: Build artifact

### Example 5: new-feature-dir/

- Pattern match: New directory
- Category: CONFIRM
- Action: Show contents, ask user about purpose
- Reason: Unknown purpose
