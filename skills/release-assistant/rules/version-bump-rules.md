# Version Bump Rules

Semantic Versioning (SemVer) rules for determining version bumps based on commit history.

## Format: MAJOR.MINOR.PATCH

Example: `0.3.0`

- **MAJOR**: Breaking changes, incompatible API changes
- **MINOR**: New features, backward-compatible additions
- **PATCH**: Bug fixes, backward-compatible patches

## Decision Tree

### 1. Check for BREAKING CHANGE (MAJOR bump)

**Triggers:**
- Commit message contains `BREAKING CHANGE:` in body or footer
- Commit message contains `!` after type (e.g., `feat!:`, `refactor!:`)

**Examples:**
```
feat!: remove deprecated API endpoint

BREAKING CHANGE: The /api/v1/old endpoint has been removed
```

```
refactor!: change function signature

BREAKING CHANGE: getUserData() now requires authentication token
```

**Version bump:**
- `0.3.0` → `1.0.0` (first stable release)
- `1.2.3` → `2.0.0` (major update)

**Use case:**
- Removing deprecated features
- Changing API contracts
- Renaming public interfaces
- Altering function signatures

### 2. Check for Features (MINOR bump)

**Triggers:**
- Any commit with type `feat:`
- No BREAKING CHANGE present

**Examples:**
```
feat(updater): Add toast notification for updates
```

```
feat(i18n): Add Japanese localization
```

**Version bump:**
- `0.2.4` → `0.3.0`
- `1.2.3` → `1.3.0`

**Use case:**
- New features added
- New UI components
- New configuration options
- Enhanced capabilities (backward-compatible)

### 3. Everything Else (PATCH bump)

**Triggers:**
- Commits with types: `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `perf`
- No `feat` commits
- No BREAKING CHANGE

**Examples:**
```
fix(auth): Correct login validation logic
```

```
refactor(config): Remove deprecated URL generator functions
```

```
docs: Update README installation instructions
```

**Version bump:**
- `0.3.0` → `0.3.1`
- `1.2.3` → `1.2.4`

**Use case:**
- Bug fixes
- Code refactoring (no behavior change)
- Documentation updates
- Test additions
- Build system updates
- Performance improvements

## Special Cases

### Pre-1.0.0 Versions (0.x.y)

Before first stable release (`1.0.0`), version bumping is more flexible:

- **0.x.y**: Any breaking change can bump MINOR instead of MAJOR
- **Reason**: API is not yet stable, changes are expected

**Example:**
```
Current: 0.3.0
Breaking change: 0.4.0 (MINOR bump)
Feature: 0.4.0 (MINOR bump)
Fix: 0.3.1 (PATCH bump)
```

**When to go to 1.0.0:**
- API is stable
- Production-ready
- Public release
- Breaking changes will be rare

### Multiple Commit Types

If commits include multiple types since last release:

1. **Check for BREAKING CHANGE first** → MAJOR bump
2. **Check for any feat** → MINOR bump (if no breaking change)
3. **Only fix/refactor/etc** → PATCH bump

**Example:**

```bash
$ git log v0.2.4..HEAD --oneline
5499c52 feat(updater): Improve update UX with toast notifications
bfdc1d6 chore(release): Bump version to 0.3.0
04f7d08 refactor(config): Remove deprecated URL generator functions
```

**Analysis:**
- 1 `feat` commit → MINOR bump
- 1 `refactor` commit → Would be PATCH alone
- 1 `chore` commit → Ignore (release commit)

**Result:** `0.2.4` → `0.3.0` (MINOR bump due to `feat`)

### Version Consistency Check

Always verify consistency between:

1. **package.json version field**
2. **Latest git tag**

If mismatch detected:
- Show both versions to user
- Ask which is correct
- Suggest fixing before release

## Commit Type Reference

Based on Conventional Commits specification:

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `refactor` | Code refactoring | PATCH |
| `docs` | Documentation | PATCH |
| `style` | Code formatting | PATCH |
| `test` | Test additions | PATCH |
| `chore` | Maintenance | PATCH |
| `perf` | Performance | PATCH |
| `ci` | CI/CD changes | PATCH |
| `build` | Build system | PATCH |
| `revert` | Revert previous commit | PATCH |

**Note:** Any type with `!` or `BREAKING CHANGE` → MAJOR bump

## Edge Cases

### No Commits Since Last Release

**Scenario:** Tag already exists for current version

**Action:**
- Warn user: "No new commits since last release"
- Suggest: "Make some changes first, or delete the tag"
- ABORT release

### Untagged Repository

**Scenario:** No git tags exist (first release)

**Action:**
- Read current version from `package.json`
- Suggest this as first release tag
- Recommend: Start with `v0.1.0` or `v1.0.0`

### Manual Version Override

**Scenario:** User wants specific version regardless of commit history

**Action:**
- Allow user to specify version manually
- Warn if it violates SemVer rules
- Require explicit confirmation
- Document reasoning in release commit

## Examples from This Project

### Recent Release: v0.3.0

```bash
Commits since v0.2.4:
- feat(updater,i18n): Improve update UX with toast notifications
- refactor(config): Remove deprecated URL generator functions
```

**Analysis:**
- 1 `feat` commit → MINOR bump
- 1 `refactor` commit

**Decision:** `0.2.4` → `0.3.0` ✅

**Reasoning:** New features (toast notifications, i18n) added

### Hypothetical: v0.3.1

```bash
Commits since v0.3.0:
- fix(updater): Handle 404 errors correctly
- docs: Update CLAUDE.md
```

**Analysis:**
- 1 `fix` commit → PATCH bump
- 1 `docs` commit

**Decision:** `0.3.0` → `0.3.1` ✅

**Reasoning:** Only bug fixes and docs, no new features

### Hypothetical: v1.0.0

```bash
Commits since v0.3.0:
- feat: Complete feature set for production
- docs: Finalize API documentation
- BREAKING CHANGE: Remove all deprecated APIs
```

**Analysis:**
- BREAKING CHANGE present → MAJOR bump
- Ready for stable release

**Decision:** `0.3.0` → `1.0.0` ✅

**Reasoning:** API is stable, breaking changes made, ready for production

## References

- [Semantic Versioning 2.0.0](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
