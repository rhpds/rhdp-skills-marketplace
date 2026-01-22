# Release Scripts

Scripts for managing RHDP Skills Marketplace releases.

## create-release.sh

Automated script to create new releases with git tags and GitHub releases.

### Prerequisites

- Git installed
- GitHub CLI (`gh`) installed: `brew install gh`
- Authenticated with GitHub: `gh auth login`
- On `main` branch with no uncommitted changes

### Usage

```bash
# From repository root:
./scripts/create-release.sh
```

The script will:

1. Check prerequisites (git, gh CLI, clean working tree)
2. Show current version
3. Prompt for new version (e.g., `v1.1.0`)
4. Extract changelog from `[Unreleased]` section
5. Update `VERSION` file
6. Update `CHANGELOG.md` (move Unreleased to new version)
7. Commit changes
8. Create git tag
9. Push to GitHub
10. Create GitHub release with changelog notes

### Before Running

Always update `CHANGELOG.md` first:

```markdown
## [Unreleased]

### Added
- New feature X
- New skill Y

### Changed
- Updated behavior of Z

### Fixed
- Bug fix for A
```

### Version Format

Use semantic versioning: `vMAJOR.MINOR.PATCH`

- `vX.0.0` - Major release (breaking changes)
- `vX.Y.0` - Minor release (new features, backwards compatible)
- `vX.Y.Z` - Patch release (bug fixes)

Examples:
- `v1.0.0` - Initial release
- `v1.1.0` - Added new skills
- `v1.1.1` - Bug fixes

### After Release

1. Verify release on GitHub: https://github.com/rhpds/rhdp-skills-marketplace/releases
2. Test installation:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
   ```
3. Test update:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash
   ```
4. Announce in [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) Slack channel

## Manual Release Process

If you prefer to create releases manually:

1. Update `CHANGELOG.md`:
   - Move `[Unreleased]` content to new version section
   - Add date: `## [v1.1.0] - 2026-01-22`
   - Add new empty `[Unreleased]` section

2. Update `VERSION` file:
   ```bash
   echo "v1.1.0" > VERSION
   ```

3. Commit and tag:
   ```bash
   git add VERSION CHANGELOG.md
   git commit -m "Release v1.1.0"
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin main
   git push origin v1.1.0
   ```

4. Create GitHub release:
   ```bash
   gh release create v1.1.0 \
     --title "Release v1.1.0" \
     --notes "$(awk '/## \[v1.1.0\]/,/## \[/{if (/## \[/ && NR!=1) exit; print}' CHANGELOG.md | tail -n +2)"
   ```

## Troubleshooting

**"gh: command not found"**
- Install GitHub CLI: `brew install gh`

**"gh: not authenticated"**
- Run: `gh auth login`

**"Must be on main branch"**
- Switch to main: `git checkout main`
- Pull latest: `git pull origin main`

**"Uncommitted changes"**
- Commit your changes: `git add . && git commit -m "Your message"`
- Or stash them: `git stash`

**"No [Unreleased] section"**
- Add changes to `CHANGELOG.md` under `## [Unreleased]` first
