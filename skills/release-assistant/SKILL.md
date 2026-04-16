---
name: release-assistant
description: Automates and ensures reliable release workflows with automatic version bump based on commit history, mandatory lint/build/test execution before release, and safe tag creation and push. Supports Node/Bun and Go projects.
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Release Assistant Skill

Automate release workflows: Lint → Build → Test → Version Bump → Tag → Push.

## Activation Triggers

- "release", "version bump"
- `/patch-release` → Patch Release flow

## Project Type Detection

| Indicator | Project type | Version source | Bump method |
|-----------|-------------|---------------|-------------|
| `package.json` present | Node/Bun | `package.json` | Edit file + tag |
| `go.mod` only (no package.json) | Go | git tag | Tag only (no file edit) |
| `Cargo.toml` | Rust | `Cargo.toml` | Edit file + tag |
| Other | Unknown | Ask user | Abort and confirm |

Git tag format is `vX.Y.Z` for all types.

## Workflow

### Phase 1: Pre-flight Checks

**Do NOT proceed until ALL checks pass.**

1. `git status` — abort if uncommitted changes
2. Run project's lint / build / test commands (check `package.json` scripts, `Makefile`, or standard defaults like `go build ./...` / `go test ./...`)
   - **lint** failure: try auto-fix (`--write` etc.), abort if not fixable
   - **build** failure: abort
   - **test** failure: abort (skip phase if no test target defined)

### Phase 2: Version Analysis

1. Determine current version:
   - Node: `package.json` + latest `v*` tag
   - Go: latest `v*` tag only
2. Analyze commits: `git log <last-tag>..HEAD --oneline`
3. Determine bump type (Conventional Commits):
   - **MAJOR**: `BREAKING CHANGE` or `type!:` present
   - **MINOR**: `feat:` present (no breaking)
   - **PATCH**: only `fix`/`refactor`/`docs`/`chore`
4. Group commits by type, present summary to user

### Phase 3: Version Bump & Commit

1. Propose new version, get user confirmation (override allowed)
2. Node/Rust: Edit manifest file. Go: skip file edit
3. Commit (Node/Rust only) and create tag:
   ```
   chore(release): Bump version to X.Y.Z

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```
   ```bash
   git tag vX.Y.Z
   ```

### Phase 4: Push

1. Confirm push with user (show branch name and tag)
2. `git push origin <branch> && git push origin vX.Y.Z`
3. Show release summary, prompt to check CI/CD pipeline

## Patch Release (`/patch-release`)

Simplified flow for bug-fix-only releases (no `feat` commits).

- Skip version analysis (always PATCH)
- Tests optional (build includes type checking for Node)
- Skip changelog, minimize confirmation steps

## Error Handling

| Error | Action |
|-------|--------|
| Lint failure | Auto-fix with `--write` → abort if not fixable |
| Test/Build failure | Abort, prompt to fix |
| Uncommitted changes | Suggest commit/stash, abort |
| Tag already exists | Abort, suggest delete or different version |
| Push failure | Suggest solution based on error message |
