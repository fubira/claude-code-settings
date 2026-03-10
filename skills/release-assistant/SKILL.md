---
name: release-assistant
description: Automates and ensures reliable release workflows with automatic version bump based on commit history, mandatory lint/build/test execution before release, and safe tag creation and push.
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# Release Assistant Skill

Automate release workflows: Lint → Build → Test → Version Bump → Tag → Push.

## Activation Triggers

- "release", "version bump"
- `/patch-release` → Patch Release flow

## Workflow

### Phase 1: Pre-flight Checks

**Do NOT proceed until ALL checks pass.**

1. `git status` to verify clean working tree (abort if uncommitted changes)
2. Check `package.json` scripts, run with project's package manager:
   - **lint**: On failure, try auto-fix (`--write` etc.), abort if not fixable
   - **build**: Abort on failure (includes `tsc -b` type checking)
   - **test**: Abort on failure (skip if no test script defined)

### Phase 2: Version Analysis

1. Determine current version from `package.json` version and latest git tag (`v*`)
2. Analyze commits with `git log <last-tag>..HEAD --oneline`
3. Determine version bump type based on Conventional Commits:
   - **MAJOR**: `BREAKING CHANGE` present
   - **MINOR**: `feat` present (no breaking)
   - **PATCH**: Only `fix`, `refactor`, `docs`, `chore`, etc.
4. Group commits by type, present change summary to user

### Phase 3: Version Bump & Commit

1. Propose new version, get user confirmation (override allowed)
2. Update `package.json` with Edit tool
3. Commit and create tag:
   ```
   chore(release): Bump version to X.Y.Z

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
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
- Tests optional (build includes type checking)
- Skip changelog, minimize confirmation steps

## Error Handling

| Error | Action |
|-------|--------|
| Lint failure | Auto-fix with `--write` → abort if not fixable |
| Test/Build failure | Abort, prompt to fix |
| Uncommitted changes | Suggest commit/stash, abort |
| Tag already exists | Abort, suggest delete or different version |
| Push failure | Suggest solution based on error message |
