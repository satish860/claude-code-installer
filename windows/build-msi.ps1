# Build script for Claude Code MSI Installer
# Requires WiX Toolset 3.11 or later

$ErrorActionPreference = "Stop"

Write-Host "Building Claude Code MSI Installer..." -ForegroundColor Cyan

# Check if WiX is installed
$wixPath = "${env:WIX}bin"
if (-not (Test-Path $wixPath)) {
    Write-Host "[ERROR] WiX Toolset not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install WiX Toolset from:" -ForegroundColor Yellow
    Write-Host "https://github.com/wixtoolset/wix3/releases" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or install via winget:" -ForegroundColor Yellow
    Write-Host "  winget install WiXToolset.WiX" -ForegroundColor Yellow
    exit 1
}

$candle = Join-Path $wixPath "candle.exe"
$light = Join-Path $wixPath "light.exe"

# Clean previous builds
if (Test-Path "obj") {
    Remove-Item "obj" -Recurse -Force
}
if (Test-Path "ClaudeCodeInstaller.msi") {
    Remove-Item "ClaudeCodeInstaller.msi" -Force
}

New-Item -ItemType Directory -Force -Path "obj" | Out-Null

Write-Host "[STEP] Compiling WiX source..." -ForegroundColor Cyan
& $candle -out "obj\\" claude-code-installer.wxs

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Compilation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP] Linking installer..." -ForegroundColor Cyan
& $light -out "ClaudeCodeInstaller.msi" -ext WixUIExtension "obj\claude-code-installer.wixobj"

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Linking failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[OK] MSI installer built successfully!" -ForegroundColor Green
Write-Host "Output: ClaudeCodeInstaller.msi" -ForegroundColor Green
Write-Host ""
