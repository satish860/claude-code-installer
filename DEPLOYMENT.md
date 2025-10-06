# Deployment Guide

This guide walks you through setting up this project on GitHub with automated builds and releases.

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon > "New repository"
3. Fill in:
   - Repository name: `claude-code-installer` (or your preferred name)
   - Description: "One-click installers for Claude Code on Windows and macOS"
   - Visibility: Public (recommended) or Private
   - DO NOT initialize with README (we already have one)
4. Click "Create repository"

## Step 2: Update Repository URLs

Before pushing, update placeholder URLs in these files:

### README.md
Replace `satish860/claude-code-installer` with your actual GitHub username and repository name:
- Badge URLs (lines 3-5)
- Download links (line 12, 28, 34)

### Scripts
Update in these files:
- `scripts/create-release.ps1` (last 3 lines)
- `scripts/create-release.sh` (last 3 lines)

Quick find and replace:
```bash
# On Unix/Mac/Git Bash
find . -type f \( -name "*.md" -o -name "*.ps1" -o -name "*.sh" \) -exec sed -i 's/YOUR_USERNAME\/YOUR_REPO/yourusername\/yourrepo/g' {} +

# On Windows PowerShell
Get-ChildItem -Recurse -Include *.md,*.ps1,*.sh | ForEach-Object {
    (Get-Content $_.FullName) -replace 'satish860/claude-code-installer', 'yourusername/yourrepo' | Set-Content $_.FullName
}
```

## Step 3: Initialize Git and Push

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "feat: Initial commit with Windows and macOS installers"

# Add remote (replace with your repository URL)
git remote add origin https://github.com/satish860/claude-code-installer.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Verify GitHub Actions

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. You should see workflows running for:
   - Build Windows Installer
   - Build macOS Installer
4. Wait for builds to complete (5-10 minutes)
5. Check that both builds succeed

If builds fail:
- Click on the failed workflow
- Review the logs
- Common issues:
  - WiX installation timeout on Windows
  - Permission issues
  - Missing files

## Step 5: Create Your First Release

### Method 1: Using the Script (Recommended)

**Windows:**
```powershell
.\scripts\create-release.ps1 -Version 1.0.0
```

**Mac/Linux:**
```bash
chmod +x scripts/create-release.sh
./scripts/create-release.sh --version 1.0.0
```

### Method 2: Manual Git Tag

```bash
# Tag the current commit
git tag v1.0.0

# Push the tag
git push origin v1.0.0
```

### Method 3: GitHub UI

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "Create Release" workflow
4. Click "Run workflow"
5. Enter version (e.g., v1.0.0)
6. Click "Run workflow"

## Step 6: Monitor Release Creation

1. Go to "Actions" tab on GitHub
2. Watch the "Create Release" workflow
3. It will:
   - Build Windows MSI
   - Build macOS PKG
   - Create GitHub Release
   - Attach installers
   - Generate checksums

## Step 7: Verify Release

1. Go to "Releases" on your GitHub repository
2. You should see "Release v1.0.0"
3. Verify attached files:
   - ClaudeCodeInstaller.msi
   - ClaudeCodeInstaller.pkg
   - checksums.txt
4. Download and test both installers

## Step 8: Share with Friends

Now you can share your repository URL:
```
https://github.com/satish860/claude-code-installer
```

Your friends can:
- Download from the [Releases](https://github.com/satish860/claude-code-installer/releases/latest) page
- Follow instructions in QUICK_START.md
- Report issues in the Issues tab

## Automated Release Workflow

Every time you push a tag:
```bash
git tag v1.0.1
git push origin v1.0.1
```

GitHub Actions will:
1. Build both installers
2. Run tests
3. Create a release
4. Upload installers as assets

## Optional: Enable GitHub Pages

To host documentation:

1. Go to repository Settings
2. Scroll to "Pages"
3. Source: Deploy from a branch
4. Branch: main
5. Folder: / (root)
6. Save

Your documentation will be available at:
```
https://YOUR_USERNAME.github.io/YOUR_REPO/
```

## Optional: Add Code Signing

### Windows Code Signing

1. Obtain a code signing certificate
2. Add certificate as GitHub secret:
   - Settings > Secrets and variables > Actions
   - New repository secret
   - Name: `WINDOWS_CERTIFICATE`
   - Value: Base64-encoded .pfx file
3. Add certificate password as secret:
   - Name: `WINDOWS_CERT_PASSWORD`
4. Update `.github/workflows/release.yml` to sign MSI

### macOS Code Signing

1. Enroll in Apple Developer Program
2. Create Developer ID Application certificate
3. Add secrets to GitHub:
   - `MACOS_CERTIFICATE`
   - `MACOS_CERTIFICATE_PASSWORD`
4. Update `.github/workflows/release.yml` to sign PKG

See [GitHub docs on code signing](https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development) for details.

## Troubleshooting

### Build Failures

**WiX installation timeout:**
- Edit `.github/workflows/build-windows.yml`
- Increase timeout or use cached WiX

**Permission errors on macOS:**
- Verify script permissions in repository
- Add `chmod +x` step if needed

**Artifact upload failures:**
- Check artifact paths
- Verify files are created

### Release Failures

**Tag already exists:**
```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin :refs/tags/v1.0.0
```

**Push rejected:**
- Ensure you have write access to repository
- Check if branch is protected
- Verify GitHub token permissions

### Badge Not Showing

- Badges may take a few minutes to appear
- Check workflow names match badge URLs
- Verify repository is public (or badge tokens configured)

## Updating the Installers

1. Make changes to scripts
2. Test locally
3. Commit and push:
   ```bash
   git add .
   git commit -m "fix: Improve error handling"
   git push
   ```
4. Create new release:
   ```bash
   ./scripts/create-release.sh --version 1.0.1
   ```

## Monitoring and Maintenance

### Check Build Status
- GitHub Actions tab shows all workflow runs
- Set up email notifications in GitHub settings

### Monitor Issues
- Enable issue notifications
- Respond to user reports
- Label and organize issues

### Update Dependencies
- Node.js version in installers
- GitHub Actions versions
- WiX Toolset version

## Best Practices

1. **Test Before Release**: Always test installers locally first
2. **Semantic Versioning**: Use MAJOR.MINOR.PATCH (e.g., 1.2.3)
3. **Changelog**: Document changes in release notes
4. **Security**: Never commit certificates or secrets
5. **Communication**: Update users about new releases

## Support Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [WiX Toolset Documentation](https://wixtoolset.org/documentation/)
- [Apple Developer Documentation](https://developer.apple.com/)

## Next Steps

After deployment:

1. Star your own repository
2. Add topics: `claude-code`, `installer`, `windows`, `macos`
3. Create CHANGELOG.md for tracking changes
4. Set up GitHub Discussions for community support
5. Add contributors as collaborators

---

**Congratulations!** Your Claude Code installers are now on GitHub with automated builds and releases!
