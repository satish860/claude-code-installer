# GitHub Setup - Quick Start Guide

This is your step-by-step checklist for publishing this project to GitHub.

## Prerequisites

- [ ] GitHub account created
- [ ] Git installed on your computer
- [ ] Repository files ready in `C:\Source\Claude_Agent`

## Step-by-Step Checklist

### 1. Create GitHub Repository

- [ ] Go to https://github.com/new
- [ ] Repository name: `claude-code-installer` (or your choice)
- [ ] Description: "One-click installers for Claude Code"
- [ ] Choose Public or Private
- [ ] **DO NOT** check "Add a README file"
- [ ] **DO NOT** check "Add .gitignore"
- [ ] **DO NOT** choose a license
- [ ] Click "Create repository"
- [ ] Copy the repository URL (e.g., `https://github.com/username/repo.git`)

### 2. Update Configuration Files

Replace `satish860/claude-code-installer` with your actual username and repository name in:

- [ ] `README.md` (lines with badges and download links)
- [ ] `scripts/create-release.ps1` (GitHub URLs at the end)
- [ ] `scripts/create-release.sh` (GitHub URLs at the end)
- [ ] `CHANGELOG.md` (version links at the bottom)
- [ ] `DEPLOYMENT.md` (example URLs)

**Quick Replace (PowerShell):**
```powershell
$username = "YOUR_GITHUB_USERNAME"
$repo = "YOUR_REPO_NAME"

Get-ChildItem -Recurse -Include *.md,*.ps1,*.sh | ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace 'satish860/claude-code-installer', "$username/$repo" | Set-Content $_.FullName -NoNewline
}
```

### 3. Initialize Git Repository

```powershell
# Navigate to project directory
cd C:\Source\Claude_Agent

# Initialize git (if not already initialized)
git init

# Check what files will be committed
git status

# Add all files
git add .

# Create initial commit
git commit -m "feat: Initial release with Windows and macOS installers"
```

### 4. Connect to GitHub

```powershell
# Add remote (replace with your repository URL)
git remote add origin https://github.com/satish860/claude-code-installer.git

# Verify remote
git remote -v

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

If you get authentication errors, see [GitHub Authentication](#github-authentication) below.

### 5. Verify Upload

- [ ] Go to your repository URL on GitHub
- [ ] Check that all files are present:
  - [ ] README.md displays correctly
  - [ ] LICENSE file is present
  - [ ] `.github/workflows/` folder exists
  - [ ] `windows/` and `mac/` folders present
  - [ ] All documentation files visible

### 6. Test GitHub Actions

- [ ] Go to "Actions" tab in your repository
- [ ] You should see three workflows:
  - [ ] Build Windows Installer
  - [ ] Build macOS Installer
  - [ ] Create Release
- [ ] Click on each to verify they're recognized
- [ ] Wait for initial builds to start (may take a few minutes)

### 7. Create First Release

**Option A: Using the script (recommended)**

```powershell
# Windows
.\scripts\create-release.ps1 -Version 1.0.0

# Check with dry run first
.\scripts\create-release.ps1 -Version 1.0.0 -DryRun
```

**Option B: Manual**

```powershell
# Tag the release
git tag -a v1.0.0 -m "Release v1.0.0"

# Push the tag
git push origin v1.0.0
```

### 8. Monitor Release Build

- [ ] Go to "Actions" tab
- [ ] Click on "Create Release" workflow run
- [ ] Watch the progress (takes 10-15 minutes):
  - [ ] Build Windows installer
  - [ ] Build macOS installer
  - [ ] Create release
  - [ ] Upload artifacts

### 9. Verify Release

- [ ] Go to "Releases" on your repository
- [ ] Click on "v1.0.0" release
- [ ] Verify these files are attached:
  - [ ] `ClaudeCodeInstaller.msi`
  - [ ] `ClaudeCodeInstaller.pkg`
  - [ ] `checksums.txt`
- [ ] Release notes are formatted correctly

### 10. Test Download

- [ ] Download `ClaudeCodeInstaller.msi`
- [ ] Verify file size is reasonable (> 1MB)
- [ ] (Optional) Test installation on clean Windows VM
- [ ] Download `ClaudeCodeInstaller.pkg` (if you have Mac)
- [ ] (Optional) Test installation on Mac

### 11. Update Repository Settings

- [ ] Go to repository Settings
- [ ] Under "General":
  - [ ] Add topics: `claude-code`, `installer`, `windows`, `macos`, `nodejs`
  - [ ] Update description if needed
  - [ ] Add website URL (if you have one)
- [ ] Under "Options":
  - [ ] Enable Issues
  - [ ] Enable Discussions (optional but recommended)
  - [ ] Disable Wiki (unless you plan to use it)

### 12. Share Your Project

You can now share:
- Repository URL: `https://github.com/satish860/claude-code-installer`
- Latest release: `https://github.com/satish860/claude-code-installer/releases/latest`
- Quick start guide: Share `QUICK_START.md` with friends

## GitHub Authentication

If you get authentication errors when pushing:

### Option 1: HTTPS with Personal Access Token

1. Go to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (full control)
4. Copy the token
5. When prompted for password, use the token instead

### Option 2: SSH

1. Generate SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
2. Add to GitHub: Settings > SSH and GPG keys > New SSH key
3. Update remote:
   ```bash
   git remote set-url origin git@github.com:satish860/claude-code-installer.git
   ```

### Option 3: GitHub Desktop

Download [GitHub Desktop](https://desktop.github.com/) for a GUI experience.

## Troubleshooting

### "Repository not found" error
- Check repository URL is correct
- Verify you have access to the repository
- Try re-adding the remote: `git remote remove origin` then `git remote add origin <URL>`

### "Failed to push" error
- Check internet connection
- Verify authentication (see above)
- Check if repository exists on GitHub

### GitHub Actions not running
- Go to Actions tab
- Check if Actions are enabled
- Look for error messages in workflow files

### Badge not showing in README
- Wait a few minutes for first workflow run
- Check workflow names match badge URLs
- Ensure repository is public (or configure badge tokens for private)

### Build failures in Actions
- Click on failed workflow
- Read error logs
- Common issues:
  - WiX Toolset installation timeout (Windows)
  - File not found (check paths)
  - Permission denied (check file permissions)

## Next Steps After Publishing

1. **Share with friends**: Send them the Quick Start guide
2. **Monitor issues**: Respond to user questions
3. **Update regularly**: Keep installers working with latest Claude Code
4. **Get feedback**: Ask users what could be improved
5. **Star your repo**: Show it some love!

## Quick Command Reference

```powershell
# Check repository status
git status

# View commit history
git log --oneline

# View remote URL
git remote -v

# Create and push a tag
git tag v1.0.1
git push origin v1.0.1

# Pull latest changes
git pull

# View differences
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# View all tags
git tag -l
```

## Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Documentation](https://docs.github.com)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Markdown Guide](https://www.markdownguide.org/)

## Getting Help

If you get stuck:
1. Read error messages carefully
2. Search on [Stack Overflow](https://stackoverflow.com)
3. Check [GitHub Community](https://github.community)
4. Ask in [GitHub Discussions](https://github.com/satish860/claude-code-installer/discussions)

---

## Post-Setup Checklist

After everything is set up:

- [ ] README displays correctly on GitHub
- [ ] Badges show build status
- [ ] First release (v1.0.0) is published
- [ ] Both installers are downloadable
- [ ] GitHub Actions workflows pass
- [ ] Repository topics are set
- [ ] You've tested the download links
- [ ] You've shared with at least one friend

**Congratulations! Your project is live on GitHub!**
