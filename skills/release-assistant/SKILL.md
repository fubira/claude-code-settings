# Release Assistant Skill

## Purpose

Automate and ensure reliable release workflows with:

- Automatic version bump based on commit history
- Mandatory lint and test execution before release
- Safe tag creation and push
- Semantic versioning (SemVer) compliance

## Activation Triggers

Automatically activate when:

- User says "リリース", "release", "リリースして"
- User mentions "バージョンアップ", "version bump", "タグを切る"
- User asks to publish or deploy a new version

## Workflow

### Phase 1: Pre-flight Checks

**CRITICAL: These checks MUST pass before proceeding**

1. **Check working directory**
   - Run `git status` to verify clean working tree
   - If uncommitted changes exist:
     - Show changes to user
     - Ask if they want to commit first
     - Offer to abort release

2. **Run linter**
   - Execute project-specific lint command:
     - `bun run lint` (Bun projects)
     - `npm run lint` (npm projects)
     - `pnpm lint` (pnpm projects)
   - If lint fails:
     - Show errors to user
     - Fix automatically if possible (e.g., `--write` flag)
     - Ask user to fix manually if auto-fix unavailable
     - ABORT release until lint passes

3. **Run tests**
   - Execute project-specific test command:
     - `bun test` (Bun projects)
     - `npm test` (npm projects)
     - `pnpm test` (pnpm projects)
   - If tests fail:
     - Show failed tests to user
     - ABORT release until tests pass
     - Suggest running tests locally first

4. **Run type check** (TypeScript projects)
   - Execute `bun run typecheck` or equivalent
   - If type errors exist:
     - Show errors to user
     - ABORT release until type check passes

**Only proceed if ALL checks pass**

### Phase 2: Version Analysis

1. **Find current version**
   - Read `package.json` version field
   - Find latest git tag (format: `v*`)
   - Compare to ensure consistency

2. **Analyze commits since last release**
   - Run `git log <last-tag>..HEAD --oneline`
   - Parse commit messages for Conventional Commits format
   - Categorize commits:
     - `feat`: New features
     - `fix`: Bug fixes
     - `BREAKING CHANGE`: Breaking changes
     - `refactor`, `docs`, `style`, `test`, `chore`: Minor changes

3. **Calculate version bump type**
   - Based on commit analysis:
     - **MAJOR**: If any `BREAKING CHANGE` found
     - **MINOR**: If any `feat` found (and no breaking changes)
     - **PATCH**: If only `fix`, `refactor`, `docs`, `style`, `test`, `chore`
   - Apply SemVer rules (see `rules/version-bump-rules.md`)

4. **Generate changelog summary**
   - Group commits by type
   - Create human-readable summary
   - Show to user for review

### Phase 3: Version Bump

1. **Propose new version**
   - Calculate next version based on bump type
   - Examples:
     - `0.2.4` → `0.3.0` (MINOR bump for feat)
     - `0.3.0` → `1.0.0` (MAJOR bump for breaking change)
     - `0.3.0` → `0.3.1` (PATCH bump for fix)

2. **Confirm with user**
   - Show current version
   - Show proposed version
   - Show reasoning (what commits triggered this bump)
   - Allow user to override if needed

3. **Update package.json**
   - Use Edit tool to update version field
   - Preserve exact formatting

### Phase 4: Commit & Tag

1. **Commit version bump**
   - Stage `package.json`
   - Create commit with message:
     ```
     chore(release): Bump version to X.Y.Z

     🤖 Generated with [Claude Code](https://claude.com/claude-code)

     Co-Authored-By: Claude <noreply@anthropic.com>
     ```

2. **Create git tag**
   - Format: `vX.Y.Z` (e.g., `v0.3.0`)
   - Run `git tag vX.Y.Z`
   - Verify tag creation with `git tag -l "vX.Y.*"`

3. **Verify git status**
   - Run `git status` to confirm clean state
   - Run `git log -1` to show latest commit

### Phase 5: Push

1. **Confirm push**
   - Ask user: "Ready to push commits and tags to remote?"
   - Show what will be pushed:
     - Branch: `main` (or current branch)
     - Tag: `vX.Y.Z`

2. **Push to remote**
   - Push commits: `git push origin <branch>`
   - Push tags: `git push origin vX.Y.Z`
   - Verify success

3. **Post-release summary**
   - Show release summary:
     - Version: `vX.Y.Z`
     - Commits included: N commits
     - Changes: Brief summary
     - Tag pushed: ✅
   - Remind user about CI/CD:
     - "CI/CD pipeline will now build and deploy this release"
     - "Monitor GitHub Actions for deployment status"

## Version Bump Rules

Detailed rules in `rules/version-bump-rules.md`:

- **MAJOR (X.0.0)**: Breaking changes, API changes
- **MINOR (0.X.0)**: New features, backward-compatible changes
- **PATCH (0.0.X)**: Bug fixes, refactoring, docs

## Release Checklist

See `templates/release-checklist.md` for complete checklist.

## Error Handling

### Lint failures
- Action: Show errors, offer to auto-fix with `--write`
- If auto-fix unavailable: Ask user to fix manually
- ABORT release until resolved

### Test failures
- Action: Show failed tests with details
- ABORT release immediately
- Suggest: "Fix tests first, then re-run release"

### Type check failures
- Action: Show type errors
- ABORT release until resolved

### Uncommitted changes
- Action: Show changes, ask user to commit or stash
- Offer to commit automatically if changes are simple
- ABORT release if user declines

### Tag already exists
- Action: Check if tag already exists remotely
- If exists: ABORT with error message
- Suggest: Delete tag locally/remotely or use different version

### Push failures
- Action: Show error message from git
- Common causes:
  - No remote configured
  - Permission denied
  - Network issues
- Suggest solutions based on error

## Integration with Global CLAUDE.md

Add to global CLAUDE.md:

```markdown
## リリース作業

リリースは `release-assistant` Skill が支援する。

**基本フロー**: Lint → Test → Version Bump → Tag → Push

詳細は `~/.claude/skills/release-assistant/SKILL.md` を参照。
```

## Safety Guarantees

This Skill provides these safety guarantees:

1. **No release without passing lint** - Code quality assured
2. **No release without passing tests** - Functionality verified
3. **No release with uncommitted changes** - Clean state guaranteed
4. **No release without user confirmation** - Manual approval required
5. **Semantic versioning enforced** - Predictable version numbers

## Usage Tips

### When to use this Skill

- ✅ Ready to publish a new version
- ✅ All features/fixes are committed
- ✅ Tests are passing locally
- ✅ Ready to trigger CI/CD deployment

### When NOT to use this Skill

- ❌ Still working on features
- ❌ Tests are failing
- ❌ Code is not committed
- ❌ Want to create a tag without version bump

### Best practices

1. **Run tests locally first** before invoking this Skill
2. **Review commit history** to ensure all changes are included
3. **Check CI/CD status** after push to verify deployment
4. **Use conventional commits** for automatic version detection

## Maintenance

Update this Skill when:

- New test frameworks are adopted
- Linter configuration changes
- Release process requirements evolve
- New project types need support
