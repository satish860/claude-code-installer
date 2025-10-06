# Claude Code Installer Project - Overview

## What You Have

Complete one-click installer solutions for Claude Code on both Windows and macOS, designed for non-technical users.

## Project Structure

```
Claude_Agent/
├── README.md                        # Technical documentation & build instructions
├── QUICK_START.md                   # User-friendly installation guide
├── DISTRIBUTION_GUIDE.md            # How to share with friends
├── OVERVIEW.md                      # This file
│
├── windows/                         # Windows installer files
│   ├── install-claude-code.ps1      # Main installation script
│   ├── Install-Claude-Code.bat      # Double-click installer (easiest!)
│   ├── claude-code-installer.wxs    # MSI configuration (WiX)
│   ├── build-msi.ps1                # Script to build MSI
│   └── license.rtf                  # License for MSI
│
└── mac/                             # macOS installer files
    ├── install-claude-code.sh       # Main installation script
    └── build-pkg.sh                 # Script to build .pkg
```

## Quick Actions

### For Immediate Use (No Building Required)

**Windows users:**
```powershell
cd windows
.\Install-Claude-Code.bat
```

**Mac users:**
```bash
cd mac
chmod +x install-claude-code.sh
./install-claude-code.sh
```

### To Build Distribution Packages

**Windows MSI:**
```powershell
# Requires WiX Toolset
cd windows
.\build-msi.ps1
# Creates: ClaudeCodeInstaller.msi
```

**Mac PKG:**
```bash
# Requires macOS with Xcode Command Line Tools
cd mac
chmod +x build-pkg.sh
./build-pkg.sh
# Creates: ClaudeCodeInstaller.pkg
```

## What Each File Does

### Documentation Files

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Complete technical documentation | Developers building installers |
| `QUICK_START.md` | Simple installation instructions | Non-technical end users |
| `DISTRIBUTION_GUIDE.md` | How to share installers | You (the distributor) |
| `OVERVIEW.md` | Project summary | Quick reference |

### Windows Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `Install-Claude-Code.bat` | Simple double-click installer | Easiest option, no building required |
| `install-claude-code.ps1` | PowerShell installation script | Direct use or building MSI |
| `build-msi.ps1` | Builds MSI package | Creating professional installer |
| `claude-code-installer.wxs` | MSI configuration | Building with WiX |
| `license.rtf` | License text | Required for MSI |

### Mac Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `install-claude-code.sh` | Shell installation script | Direct use or building PKG |
| `build-pkg.sh` | Builds PKG package | Creating Mac installer |

## Installation Flow

### What the Installers Do

1. Check if Node.js v18+ is installed
2. If not, download and install Node.js
   - Windows: Downloads Node.js MSI and installs silently
   - Mac: Installs via Homebrew
3. Install Claude Code via npm: `npm install -g @anthropic-ai/claude-code`
4. Verify installation
5. Display next steps to user

### What Users Need to Do After

1. Open Terminal/PowerShell
2. Run: `claude`
3. Authenticate (one-time setup)
4. Start using Claude Code!

## Distribution Options

### Option 1: Share Raw Scripts (Easiest)
- Send `Install-Claude-Code.bat` to Windows users
- Send `install-claude-code.sh` to Mac users
- Include `QUICK_START.md`

### Option 2: Share Built Packages (Most Professional)
- Build `ClaudeCodeInstaller.msi` for Windows
- Build `ClaudeCodeInstaller.pkg` for Mac
- Include `QUICK_START.md`
- Upload to cloud storage and share link

### Option 3: Create Distribution Website
- Host installers on GitHub Releases
- Create simple landing page
- See `DISTRIBUTION_GUIDE.md` for HTML template

## System Requirements

### Windows
- Windows 10 or later
- PowerShell 5.1+
- 4GB+ RAM
- Internet connection

### Mac
- macOS 10.15 (Catalina) or later
- 4GB+ RAM
- Internet connection
- Terminal access

## Testing Before Distribution

1. **Test on clean Windows VM:**
   - No Node.js installed
   - Run `Install-Claude-Code.bat`
   - Verify `claude` command works

2. **Test on clean Mac:**
   - No Node.js installed
   - Run `install-claude-code.sh`
   - Verify `claude` command works

3. **Test with existing Node.js:**
   - Verify it detects existing installation
   - Verify it upgrades if version < 18

## Common Issues & Solutions

### Windows

**"Execution of scripts is disabled"**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"MSI build failed"**
- Install WiX Toolset: `winget install WiXToolset.WiX`
- Restart PowerShell after installing

### Mac

**"Permission denied"**
```bash
chmod +x install-claude-code.sh
./install-claude-code.sh
```

**"Can't be opened because it is from an unidentified developer"**
- System Preferences > Security & Privacy > "Open Anyway"

### Both Platforms

**"claude: command not found" after installation**
- Restart terminal/PowerShell
- Check PATH: Windows users may need to restart computer

## Next Steps

1. **Test locally** on your own machine
2. **Test on a friend's machine** (clean install)
3. **Build the packages** if needed
4. **Read DISTRIBUTION_GUIDE.md** for sharing strategies
5. **Give QUICK_START.md** to your friends

## Maintenance

### Updating
The installers automatically get the latest Claude Code version from npm. You only need to rebuild if:
- You want to change installer behavior
- You want to update Node.js version
- You want to update documentation

### User Updates
Users can update Claude Code anytime:
```bash
npm update -g @anthropic-ai/claude-code
# or
claude update
```

## Support Resources

### For You
- `README.md` - Technical details
- `DISTRIBUTION_GUIDE.md` - Sharing strategies

### For Your Friends
- `QUICK_START.md` - Simple instructions
- Official docs: https://docs.claude.com/claude-code
- GitHub: https://github.com/anthropics/claude-code

## Key Features

- Automatic Node.js detection and installation
- Silent/unattended installation support
- Error handling and user feedback
- Cross-platform support (Windows & Mac)
- No admin/sudo required
- Professional MSI/PKG packages available
- Simple batch/shell script alternatives

## Success Tips

1. **Start simple**: Use `.bat` or `.sh` files first
2. **Build packages later**: For wider distribution
3. **Include QUICK_START.md**: Make it easy for users
4. **Be available**: First installation is always the hardest
5. **Collect feedback**: Improve documentation based on questions

## Questions?

- Check `README.md` for technical details
- Check `QUICK_START.md` for user instructions
- Check `DISTRIBUTION_GUIDE.md` for sharing strategies
- Visit https://docs.claude.com/claude-code for Claude Code help

---

**Remember:** The goal is to make Claude Code accessible to non-technical users. Start simple, test thoroughly, and provide clear instructions!
