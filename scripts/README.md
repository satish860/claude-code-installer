# Release Scripts

This directory contains scripts for creating releases.

## Scripts

### create-release.ps1 (Windows)

PowerShell script for creating versioned releases.

**Usage:**
```powershell
# Create a release
.\create-release.ps1 -Version 1.0.0

# Test without making changes
.\create-release.ps1 -Version 1.0.0 -DryRun
```

**What it does:**
1. Validates version format (X.Y.Z)
2. Checks for uncommitted changes
3. Updates version in WiX configuration
4. Creates git tag
5. Pushes to GitHub
6. Triggers automated release workflow

### create-release.sh (Mac/Linux)

Bash script for creating versioned releases (same functionality as PowerShell version).

**Usage:**
```bash
# Make executable (first time only)
chmod +x create-release.sh

# Create a release
./create-release.sh --version 1.0.0

# Test without making changes
./create-release.sh --version 1.0.0 --dry-run
```

## Version Format

Use semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

Examples:
- `1.0.0` - Initial release
- `1.1.0` - New feature added
- `1.1.1` - Bug fix
- `2.0.0` - Breaking change

## Release Process

1. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: Description of changes"
   git push
   ```

2. **Run release script:**
   ```bash
   # Windows
   .\scripts\create-release.ps1 -Version 1.0.0

   # Mac/Linux
   ./scripts/create-release.sh --version 1.0.0
   ```

3. **Monitor GitHub Actions:**
   - Go to GitHub repository
   - Click "Actions" tab
   - Watch "Create Release" workflow

4. **Verify release:**
   - Go to "Releases" tab
   - Check installers are attached
   - Test download links

## Troubleshooting

### "Not a git repository"
You're not in the project directory. Navigate to the project root.

### "Uncommitted changes"
Commit or stash your changes first:
```bash
git add .
git commit -m "Your message"
```

### "Tag already exists"
Delete the tag and try again:
```bash
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
```

### "Push failed"
Check your GitHub authentication and permissions.

## Manual Release (Alternative)

If the script doesn't work, create a release manually:

```bash
# Create tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag
git push origin v1.0.0
```

GitHub Actions will automatically build and create the release.

## Pre-Release Checklist

Before creating a release:

- [ ] All changes committed
- [ ] Tests passing locally
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number decided
- [ ] On main/master branch

## Post-Release Tasks

After release is created:

- [ ] Verify installers download correctly
- [ ] Test installation on clean system
- [ ] Update CHANGELOG.md if not done
- [ ] Announce release (if applicable)
- [ ] Close related GitHub issues

## CI/CD Flow

When you push a tag:

1. **GitHub Actions triggered**
2. **Build Windows installer** (5-7 min)
3. **Build macOS installer** (5-7 min)
4. **Create GitHub Release**
5. **Attach installers as assets**
6. **Generate checksums**
7. **Publish release notes**

Total time: ~10-15 minutes

## Version Update

The scripts automatically update:
- WiX installer configuration (`windows/claude-code-installer.wxs`)

Manual updates needed:
- CHANGELOG.md
- Documentation (if version-specific)

## Tips

1. **Use dry-run first** to preview changes
2. **Follow semantic versioning** strictly
3. **Update CHANGELOG** before releasing
4. **Test installers** after each release
5. **Tag from main branch** for stability

## Examples

```powershell
# Create first release
.\create-release.ps1 -Version 1.0.0

# Create feature release
.\create-release.ps1 -Version 1.1.0

# Create patch release
.\create-release.ps1 -Version 1.0.1

# Test release creation
.\create-release.ps1 -Version 2.0.0 -DryRun
```

## Help

For more information, see:
- [DEPLOYMENT.md](../DEPLOYMENT.md)
- [GITHUB_SETUP.md](../GITHUB_SETUP.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
