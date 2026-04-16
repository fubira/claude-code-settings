---
name: git-commit-assistant
description: Assists with careful Git commits in any repository. Activates when committing changes, checking .gitignore, or generating commit messages. Ensures proper file exclusion (credentials, MCP configs, personal settings), identifies untracked files, and generates Conventional Commits messages with Japanese explanations.
allowed-tools: [Bash, Read, Write, Edit, AskUserQuestion, Grep, Glob]
---

# Git Commit Assistant Skill

Safe, high-quality Git commits. Sensitive file exclusion, .gitignore management, Conventional Commits message generation.

## Activation Triggers

- "commit", ".gitignore", push-related requests

## Workflow

### Phase 1: Repository Analysis

1. `git status --porcelain` + `git branch --show-current` to check state
2. Read `.gitignore`, suggest missing required patterns

### Phase 2: File Classification

**AUTO_EXCLUDE (never commit)**:
- Secrets: `*.key`, `*.pem`, `*credentials*`, `*secret*`, `*password*`, `.env*`
- MCP config: `.claude.json`, `.mcp.json*`
- Personal settings: `settings.json`, `settings.local.json`, IDE configs
- Build artifacts: `node_modules/`, `dist/`, `build/`, `vendor/`, `*.log`, `*.cache`
- OS: `.DS_Store`, `Thumbs.db`

**AUTO_COMMIT (generally safe)**:
- Source code (`src/**`, `internal/**`, `lib/**`), tests, docs (`*.md`)
- Shared config (`.gitignore`, `package.json`, `tsconfig.json`, `go.mod`, `.github/workflows/*`)
- Skills/Knowledge (`~/.claude/skills/**`, `~/.claude/knowledge/**`)

**CONFIRM (user decision)**: Files > 1MB, new directories, executables, unclassified config files

### Phase 3: Commit Message Generation

1. Analyze changes from `git diff --cached` and `git status`
2. Generate Conventional Commits message:
   ```
   <type>(<scope>): <subject>  ← English, max 50 chars, imperative

   - <description (Japanese OK)>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```
   - 3-5 bullets explaining what/why/impact. No file lists
3. Present to user for confirmation

### Phase 4: Commit & Push

1. Stage with `git add` / `git rm`
2. Commit using heredoc, verify success
3. Push only after user confirmation

## Sensitive Content Scan

Scan diff before commit:
- API keys: `[A-Za-z0-9_-]{20,}`
- Passwords: `password.*=.*`
- URLs with credentials: `://.*:.*@`

Warn and abort commit on detection.

## Error Handling

| Error | Action |
|-------|--------|
| Merge conflict | Prompt resolution, show conflict files |
| Detached HEAD | Suggest `git switch -c <branch>` |
| Nothing to commit | Report clearly |

## Supporting Files

- `templates/commit-message.md`: Message template and examples
