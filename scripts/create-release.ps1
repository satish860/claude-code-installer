# Release Creation Script
# Creates a new version tag and pushes to GitHub to trigger release workflow

param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n[STEP] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Release Creation Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tag = "v$Version"

# Check if we're in a git repository
Write-Step "Checking git repository..."
try {
    git rev-parse --git-dir | Out-Null
    Write-Success "Git repository detected"
} catch {
    Write-Error "Not a git repository!"
    exit 1
}

# Check for uncommitted changes
Write-Step "Checking for uncommitted changes..."
$status = git status --porcelain
if ($status) {
    Write-Error "You have uncommitted changes:"
    git status --short
    Write-Host ""
    Write-Info "Please commit or stash your changes before creating a release."
    exit 1
}
Write-Success "Working directory is clean"

# Check if tag already exists
Write-Step "Checking if tag exists..."
$existingTag = git tag -l $tag
if ($existingTag) {
    Write-Error "Tag $tag already exists!"
    Write-Info "Use 'git tag -d $tag' to delete it locally if needed."
    exit 1
}
Write-Success "Tag $tag is available"

# Fetch latest changes
Write-Step "Fetching latest changes from remote..."
git fetch --tags
Write-Success "Fetched latest changes"

# Check if we're on main branch
Write-Step "Checking current branch..."
$currentBranch = git branch --show-current
if ($currentBranch -ne "main" -and $currentBranch -ne "master") {
    Write-Info "You are on branch: $currentBranch"
    Write-Info "Releases are typically created from 'main' or 'master' branch."
    $response = Read-Host "Continue anyway? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Info "Release cancelled."
        exit 0
    }
}
Write-Success "On branch: $currentBranch"

# Update version in WiX file
Write-Step "Updating version in WiX installer configuration..."
$wixFile = "windows\claude-code-installer.wxs"
if (Test-Path $wixFile) {
    $content = Get-Content $wixFile -Raw
    $content = $content -replace 'Version="[\d\.]+"', "Version=`"$Version.0`""
    Set-Content $wixFile $content -NoNewline
    Write-Success "Updated $wixFile"

    if (-not $DryRun) {
        git add $wixFile
        git commit -m "chore: Bump version to $Version"
        Write-Success "Committed version update"
    }
} else {
    Write-Info "WiX file not found, skipping version update"
}

if ($DryRun) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  DRY RUN - No changes made" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Info "Would create tag: $tag"
    Write-Info "Would push to remote"
    Write-Info "Remove -DryRun flag to actually create the release"
    exit 0
}

# Create the tag
Write-Step "Creating tag $tag..."
git tag -a $tag -m "Release $tag"
Write-Success "Created tag $tag"

# Push the tag
Write-Step "Pushing tag to remote..."
try {
    git push origin $tag
    Write-Success "Pushed tag to remote"
} catch {
    Write-Error "Failed to push tag!"
    Write-Info "You can manually push with: git push origin $tag"
    Write-Info "Or delete the local tag with: git tag -d $tag"
    exit 1
}

# Push the version update commit if any
Write-Step "Pushing version update commit..."
try {
    git push
    Write-Success "Pushed commits to remote"
} catch {
    Write-Error "Failed to push commits!"
    Write-Info "The tag was pushed, but the version commit was not."
    Write-Info "Manually push with: git push"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Release Created Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Success "Tag: $tag"
Write-Info "GitHub Actions will now build the installers and create a release."
Write-Info "Check progress at: https://github.com/satish860/claude-code-installer/actions"
Write-Info "Release will be available at: https://github.com/satish860/claude-code-installer/releases/tag/$tag"
Write-Host ""
