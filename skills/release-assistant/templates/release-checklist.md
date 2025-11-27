# Release Checklist

Complete checklist for release process. The `release-assistant` Skill automates these steps.

## Pre-Release (Manual)

- [ ] All planned features/fixes are implemented
- [ ] Code is committed and pushed to main branch
- [ ] Local tests pass (`bun test`)
- [ ] No known critical bugs

## Automated by Skill

### Phase 1: Pre-flight Checks

- [ ] Working directory is clean (no uncommitted changes)
- [ ] Lint passes (`bun run lint`)
- [ ] Tests pass (`bun test`)
- [ ] Type check passes (`bun run typecheck`)

### Phase 2: Version Analysis

- [ ] Current version read from `package.json`
- [ ] Latest git tag identified
- [ ] Commits since last release analyzed
- [ ] Commit types categorized (feat, fix, etc.)
- [ ] Version bump type determined (MAJOR, MINOR, PATCH)

### Phase 3: Version Bump

- [ ] New version calculated
- [ ] Version bump reasoning shown to user
- [ ] User confirms version bump
- [ ] `package.json` updated with new version

### Phase 4: Commit & Tag

- [ ] Version bump committed with `chore(release):` message
- [ ] Git tag created (format: `vX.Y.Z`)
- [ ] Tag verified with `git tag -l`
- [ ] Git status shows clean state

### Phase 5: Push

- [ ] User confirms push
- [ ] Commits pushed to remote (`git push`)
- [ ] Tags pushed to remote (`git push origin vX.Y.Z`)
- [ ] Push success verified

## Post-Release (Manual)

- [ ] Monitor CI/CD pipeline (GitHub Actions)
- [ ] Verify build success
- [ ] Verify deployment success
- [ ] Test deployed application
- [ ] Announce release (if public project)

## Rollback (If Needed)

If release fails:

1. Delete remote tag: `git push --delete origin vX.Y.Z`
2. Delete local tag: `git tag -d vX.Y.Z`
3. Revert version commit: `git revert HEAD`
4. Push revert: `git push`
5. Fix issues, then retry release

## Success Criteria

✅ Release is successful when:

- All pre-flight checks passed
- Version bump is semantic and justified
- Tag is created and pushed
- CI/CD pipeline completes successfully
- Application is deployed and working

## Common Issues

### Issue: Lint fails

**Solution:**
- Run `bun run lint` to see errors
- Fix errors manually or use auto-fix
- Re-run release after fixing

### Issue: Tests fail

**Solution:**
- Run `bun test` to see failed tests
- Fix failing tests
- Verify tests pass locally
- Re-run release

### Issue: Uncommitted changes

**Solution:**
- Run `git status` to see changes
- Commit changes or stash them
- Re-run release with clean state

### Issue: Tag already exists

**Solution:**
- Check if tag exists remotely: `git ls-remote --tags origin`
- Delete tag if needed: `git tag -d vX.Y.Z` (local)
- Delete remote tag: `git push --delete origin vX.Y.Z`
- Re-run release

### Issue: Push fails (permission denied)

**Solution:**
- Verify git credentials
- Check repository permissions
- Verify remote URL: `git remote -v`
- Try manual push to debug

## Version Bump Examples

### Example 1: MINOR bump (new features)

**Commits since last release:**
```
feat(ui): Add dark mode toggle
feat(api): Add user preferences endpoint
fix(auth): Correct token validation
```

**Analysis:**
- 2 `feat` commits → MINOR bump
- 1 `fix` commit

**Version:** `0.2.4` → `0.3.0`

### Example 2: PATCH bump (bug fixes only)

**Commits since last release:**
```
fix(updater): Handle 404 errors correctly
fix(ui): Correct button alignment
refactor(config): Simplify configuration logic
```

**Analysis:**
- 2 `fix` commits → PATCH bump
- 1 `refactor` commit
- No `feat` commits

**Version:** `0.3.0` → `0.3.1`

### Example 3: MAJOR bump (breaking changes)

**Commits since last release:**
```
feat!: Remove deprecated API endpoints

BREAKING CHANGE: /api/v1/old endpoint removed
```

**Analysis:**
- BREAKING CHANGE present → MAJOR bump

**Version:** `0.3.0` → `1.0.0`

## CI/CD Integration

After pushing tags, CI/CD typically:

1. **Build** - Compile and bundle application
2. **Test** - Run tests in CI environment
3. **Package** - Create distribution packages
4. **Deploy** - Deploy to staging/production
5. **Notify** - Send notifications (Slack, email, etc.)

**Monitor these steps** after release to ensure success.

## Notes

- Always run lint and tests before release
- Never skip pre-flight checks
- Verify CI/CD status after push
- Keep changelog updated (if manual)
- Announce releases to team/users
