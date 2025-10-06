# Claude Code One-Click Installers

[![Build Windows](https://github.com/satish860/claude-code-installer/actions/workflows/build-windows.yml/badge.svg)](https://github.com/satish860/claude-code-installer/actions/workflows/build-windows.yml)
[![Build macOS](https://github.com/satish860/claude-code-installer/actions/workflows/build-macos.yml/badge.svg)](https://github.com/satish860/claude-code-installer/actions/workflows/build-macos.yml)
[![Release](https://github.com/satish860/claude-code-installer/actions/workflows/release.yml/badge.svg)](https://github.com/satish860/claude-code-installer/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Easy-to-use installers for [Claude Code](https://claude.com/product/claude-code) for Windows and macOS. Perfect for helping non-technical users get started with Claude Code quickly.

## Download Latest Release

[**Download Latest Release**](https://github.com/satish860/claude-code-installer/releases/latest)

- Windows: `ClaudeCodeInstaller.msi`
- macOS: `ClaudeCodeInstaller.pkg`

## What This Does

These installers automate the complete setup process for Claude Code:
- Checks if Node.js is installed (required dependency)
- Installs Node.js if missing or outdated
- Installs Claude Code globally via npm
- Verifies the installation

## Installation Instructions

### Windows (.msi)
1. Download `ClaudeCodeInstaller.msi` from the [latest release](https://github.com/satish860/claude-code-installer/releases/latest)
2. Double-click the file
3. Follow the installation wizard
4. Open PowerShell and run `claude`

### macOS (.pkg)
1. Download `ClaudeCodeInstaller.pkg` from the [latest release](https://github.com/satish860/claude-code-installer/releases/latest)
2. Double-click the file
3. Follow the installation wizard (may need to allow in System Preferences > Security & Privacy)
4. Open Terminal and run `claude`

## Building the Installers Yourself

### Prerequisites

#### Windows
- PowerShell 5.1 or later
- [WiX Toolset](https://github.com/wixtoolset/wix3/releases) v3.11 or later
  - Install via: `winget install WiXToolset.WiX`

#### macOS
- macOS 10.15 or later
- Xcode Command Line Tools
  - Install via: `xcode-select --install`

### Build Instructions

#### Windows MSI

```powershell
# Navigate to the windows directory
cd windows

# Build the MSI installer
.\build-msi.ps1
```

Output: `ClaudeCodeInstaller.msi`

#### macOS PKG

```bash
# Navigate to the mac directory
cd mac

# Make the build script executable
chmod +x build-pkg.sh

# Build the PKG installer
./build-pkg.sh
```

Output: `ClaudeCodeInstaller.pkg`

### Optional: Code Signing

#### Windows
```powershell
# Sign the MSI with your certificate
signtool sign /f your-certificate.pfx /p password /tr http://timestamp.digicert.com ClaudeCodeInstaller.msi
```

#### macOS
```bash
# Sign the PKG with your Developer ID
productsign --sign "Developer ID Installer: Your Name" \
             ClaudeCodeInstaller.pkg \
             ClaudeCodeInstaller-signed.pkg
```

## Manual Installation (Alternative)

If users prefer not to use the installers, they can install manually:

### Windows
```powershell
# Run the PowerShell script directly
cd windows
.\install-claude-code.ps1
```

### macOS
```bash
# Run the shell script directly
cd mac
chmod +x install-claude-code.sh
./install-claude-code.sh
```

## What Gets Installed

1. **Node.js** (v20.11.0 for Windows, latest v20 for macOS)
   - Only installed if not already present or version < 18
   - Windows: Installed to `C:\Program Files\nodejs\`
   - macOS: Installed via Homebrew

2. **Claude Code**
   - Installed globally via npm
   - Accessible from any terminal/command prompt
   - Command: `claude`

## After Installation

1. Open a new terminal window (PowerShell on Windows, Terminal on macOS)
2. Navigate to your project directory: `cd your-project`
3. Run: `claude`
4. Follow the authentication prompts:
   - Log in via Claude Console (OAuth)
   - Or log in with your Claude.ai account (Pro/Max plan)

## System Requirements

### Windows
- Windows 10 or later
- 4GB+ RAM
- Internet connection
- PowerShell 5.1+

### macOS
- macOS 10.15 (Catalina) or later
- 4GB+ RAM
- Internet connection
- Terminal (Bash, Zsh, or Fish)

## Troubleshooting

### Windows

**Issue: "Execution of scripts is disabled on this system"**
```powershell
# Run PowerShell as Administrator and execute:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Issue: Claude command not found after installation**
- Restart your PowerShell window
- Verify installation: `npm list -g @anthropic-ai/claude-code`

### macOS

**Issue: "Permission denied" when running the installer**
```bash
# Make the script executable:
chmod +x install-claude-code.sh
```

**Issue: "App can't be opened because it is from an unidentified developer"**
- Go to System Preferences > Security & Privacy
- Click "Open Anyway" for the installer

**Issue: Claude command not found after installation**
- Restart your Terminal
- Verify installation: `npm list -g @anthropic-ai/claude-code`
- For Apple Silicon Macs, ensure Homebrew is in PATH:
  ```bash
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  source ~/.zprofile
  ```

## Support

For issues with Claude Code itself, visit:
- Documentation: https://docs.claude.com/claude-code
- GitHub Issues: https://github.com/anthropics/claude-code/issues

For issues with these installers, please check:
1. You have an active internet connection
2. Your system meets the minimum requirements
3. You have sufficient permissions (don't run as Administrator/root)

## File Structure

```
.
├── README.md
├── windows/
│   ├── install-claude-code.ps1      # PowerShell installation script
│   ├── claude-code-installer.wxs    # WiX configuration for MSI
│   ├── license.rtf                  # License file for MSI
│   └── build-msi.ps1                # Build script for MSI
└── mac/
    ├── install-claude-code.sh       # Shell installation script
    └── build-pkg.sh                 # Build script for PKG
```

## CI/CD & Automated Builds

This project uses GitHub Actions to automatically build installers for both Windows and macOS.

### Workflows

- **build-windows.yml**: Builds MSI installer on every push to main/develop
- **build-macos.yml**: Builds PKG installer on every push to main/develop
- **release.yml**: Creates GitHub releases with both installers attached

### Creating a Release

1. Tag your commit with a version:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions will automatically:
   - Build Windows MSI
   - Build macOS PKG
   - Create a GitHub Release
   - Attach both installers
   - Generate checksums

Or use manual workflow dispatch in GitHub Actions tab.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Claude Code itself is subject to Anthropic's terms of service.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Ideas for improvements:
- Add support for Linux (deb/rpm packages)
- Improve error handling
- Add uninstaller scripts
- Add GUI progress indicators
- Code signing automation
