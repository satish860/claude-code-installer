# Claude Code Installer for Windows
# This script installs Node.js (if needed) and Claude Code

param(
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "`n[STEP] $Message" -ForegroundColor Cyan
    }
}

function Write-Success {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[OK] $Message" -ForegroundColor Green
    }
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[INFO] $Message" -ForegroundColor Yellow
    }
}

function Test-NodeInstalled {
    try {
        $nodeVersion = & node --version 2>$null
        if ($nodeVersion -match 'v(\d+)\.') {
            $majorVersion = [int]$matches[1]
            return @{
                Installed = $true
                Version = $nodeVersion
                MajorVersion = $majorVersion
            }
        }
    } catch {
        return @{
            Installed = $false
            Version = $null
            MajorVersion = 0
        }
    }
    return @{
        Installed = $false
        Version = $null
        MajorVersion = 0
    }
}

function Install-NodeJS {
    Write-Step "Installing Node.js..."

    $nodeInstallerUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
    $installerPath = "$env:TEMP\node-installer.msi"

    try {
        Write-Info "Downloading Node.js installer..."
        Invoke-WebRequest -Uri $nodeInstallerUrl -OutFile $installerPath -UseBasicParsing

        Write-Info "Installing Node.js (this may take a few minutes)..."
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait -PassThru

        if ($process.ExitCode -ne 0) {
            throw "Node.js installation failed with exit code $($process.ExitCode)"
        }

        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Remove-Item $installerPath -Force
        Write-Success "Node.js installed successfully"
        return $true
    } catch {
        Write-Error "Failed to install Node.js: $_"
        if (Test-Path $installerPath) {
            Remove-Item $installerPath -Force
        }
        return $false
    }
}

function Install-ClaudeCode {
    Write-Step "Installing Claude Code..."

    try {
        Write-Info "Running: npm install -g @anthropic-ai/claude-code"

        $process = Start-Process -FilePath "npm" -ArgumentList "install -g @anthropic-ai/claude-code" -Wait -PassThru -NoNewWindow

        if ($process.ExitCode -ne 0) {
            throw "Claude Code installation failed with exit code $($process.ExitCode)"
        }

        Write-Success "Claude Code installed successfully"
        return $true
    } catch {
        Write-Error "Failed to install Claude Code: $_"
        return $false
    }
}

function Test-ClaudeCodeInstalled {
    try {
        $claudeVersion = & claude --version 2>$null
        return $claudeVersion -ne $null
    } catch {
        return $false
    }
}

# Main installation process
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code Installer for Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Info "For best results, run this installer as Administrator"
    Write-Info "Continuing with user-level installation..."
}

# Check Node.js installation
Write-Step "Checking Node.js installation..."
$nodeStatus = Test-NodeInstalled

if ($nodeStatus.Installed) {
    if ($nodeStatus.MajorVersion -ge 18) {
        Write-Success "Node.js $($nodeStatus.Version) is already installed"
    } else {
        Write-Info "Node.js $($nodeStatus.Version) is installed but version 18+ is required"
        if (-not $Silent) {
            $response = Read-Host "Would you like to upgrade Node.js? (Y/N)"
            if ($response -eq 'Y' -or $response -eq 'y') {
                if (-not (Install-NodeJS)) {
                    Write-Error "Installation aborted"
                    exit 1
                }
            } else {
                Write-Error "Node.js 18+ is required. Installation aborted."
                exit 1
            }
        } else {
            if (-not (Install-NodeJS)) {
                Write-Error "Installation aborted"
                exit 1
            }
        }
    }
} else {
    Write-Info "Node.js is not installed"
    if (-not (Install-NodeJS)) {
        Write-Error "Installation aborted"
        exit 1
    }
}

# Install Claude Code
if (-not (Install-ClaudeCode)) {
    Write-Error "Installation aborted"
    exit 1
}

# Verify installation
Write-Step "Verifying installation..."
Start-Sleep -Seconds 2

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

if (Test-ClaudeCodeInstalled) {
    Write-Success "Installation verified successfully!"
} else {
    Write-Info "Installation completed but verification failed"
    Write-Info "Please restart your terminal and try running 'claude --version'"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open a new PowerShell window" -ForegroundColor White
Write-Host "2. Navigate to your project directory" -ForegroundColor White
Write-Host "3. Run: claude" -ForegroundColor White
Write-Host "4. Follow the authentication prompts" -ForegroundColor White
Write-Host ""

if (-not $Silent) {
    Read-Host "Press Enter to exit"
}
