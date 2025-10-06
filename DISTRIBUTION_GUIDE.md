# Distribution Guide

## How to Share These Installers with Your Friends

### Step 1: Build the Installers

#### For Windows
```powershell
cd windows
.\build-msi.ps1
```
This creates: `ClaudeCodeInstaller.msi`

#### For Mac (requires macOS)
```bash
cd mac
chmod +x build-pkg.sh
./build-pkg.sh
```
This creates: `ClaudeCodeInstaller.pkg`

### Step 2: Prepare Distribution Package

Create a folder with these files:

```
Claude_Code_Installer/
├── QUICK_START.md                    # Give this to your friends!
├── Windows/
│   ├── ClaudeCodeInstaller.msi       # For Windows users
│   └── Install-Claude-Code.bat       # Alternative simple installer
└── Mac/
    └── ClaudeCodeInstaller.pkg       # For Mac users
```

### Step 3: Share the Files

#### Option A: Cloud Storage (Recommended)
1. Upload to Google Drive, Dropbox, or OneDrive
2. Create a shareable link
3. Send the link with instructions below

#### Option B: USB Drive
1. Copy the folder to a USB drive
2. Give the drive to your friends

#### Option C: Email (if files are small enough)
1. Compress the folders:
   - Windows: Right-click > Send to > Compressed folder
   - Mac: Right-click > Compress
2. Email the zip file

### Step 4: Send Instructions

Copy and paste this message to your friends:

---

**Windows Users:**
1. Download and extract the files
2. Go to the `Windows` folder
3. Double-click `Install-Claude-Code.bat` (easiest) or `ClaudeCodeInstaller.msi`
4. Follow the prompts
5. Open PowerShell and type `claude`

**Mac Users:**
1. Download and extract the files
2. Go to the `Mac` folder
3. Double-click `ClaudeCodeInstaller.pkg`
4. If you get a security warning, go to System Preferences > Security & Privacy and click "Open Anyway"
5. Follow the prompts
6. Open Terminal and type `claude`

**Read QUICK_START.md for detailed instructions!**

---

## Alternative: Direct Script Distribution

If you don't want to build installers, you can share the raw scripts:

### Windows
Share: `windows/install-claude-code.ps1`

Instructions:
```powershell
# Right-click and "Run with PowerShell"
# Or in PowerShell:
.\install-claude-code.ps1
```

### Mac
Share: `mac/install-claude-code.sh`

Instructions:
```bash
chmod +x install-claude-code.sh
./install-claude-code.sh
```

## Hosting Options

### Free Hosting Solutions

1. **GitHub Releases** (Best for developers)
   - Create a GitHub repository
   - Upload installers as release assets
   - Share the release URL

2. **Google Drive** (Best for non-technical users)
   - Upload to Google Drive
   - Set sharing to "Anyone with the link"
   - Share the link

3. **Dropbox**
   - Upload to Dropbox
   - Get shareable link
   - Share the link

4. **WeTransfer** (up to 2GB free)
   - Upload files
   - Get download link
   - Share the link (expires after 7 days)

### Creating a Simple Website

If you want to make it really easy, create a simple landing page:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Claude Code Installer</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; }
        .button { display: inline-block; padding: 15px 30px; margin: 10px; background: #4CAF50; color: white; text-decoration: none; border-radius: 5px; }
        .button:hover { background: #45a049; }
    </style>
</head>
<body>
    <h1>Install Claude Code</h1>
    <p>Choose your operating system:</p>
    <a href="path-to-windows-installer" class="button">Download for Windows</a>
    <a href="path-to-mac-installer" class="button">Download for Mac</a>
    <h2>Instructions</h2>
    <p>After downloading:</p>
    <ol>
        <li>Double-click the installer</li>
        <li>Follow the prompts</li>
        <li>Open Terminal/PowerShell</li>
        <li>Type: <code>claude</code></li>
    </ol>
</body>
</html>
```

Host this on:
- GitHub Pages (free)
- Netlify (free)
- Vercel (free)

## Pre-Distribution Checklist

Before sharing with friends:

- [ ] Test the installers on a clean Windows machine
- [ ] Test the installers on a clean Mac machine
- [ ] Verify Node.js installation works
- [ ] Verify Claude Code installation works
- [ ] Test authentication flow
- [ ] Review QUICK_START.md for clarity
- [ ] Ensure all links work
- [ ] Check file sizes (warn if large downloads)

## Support Strategy

Prepare for common questions:

1. **Create a FAQ document** based on QUICK_START.md
2. **Set up a group chat** (Discord, Slack, WhatsApp) for support
3. **Record a video tutorial** showing the installation process
4. **Be available** for the first few installations

## Legal Considerations

- These installers install open-source/freely available software (Node.js, Claude Code)
- You're not redistributing licensed software, just creating convenience installers
- Claude Code itself requires authentication with Anthropic
- Make sure your friends have Claude Code accounts or subscriptions

## Tips for Success

1. **Test first**: Install on a friend's computer before mass distribution
2. **Video tutorial**: Record your screen showing the installation
3. **Be patient**: Non-technical users may need hand-holding
4. **Simplify**: Start with the .bat file (Windows) or .pkg (Mac)
5. **Follow up**: Check in after a day to see if they got it working

## Troubleshooting Remote Support

If friends have issues:

1. **Screen share** (Zoom, Teams, Discord)
2. **Ask for screenshots** of error messages
3. **Check basics**: Internet connection, enough disk space
4. **Try manual method**: Have them run the scripts directly
5. **Last resort**: Remote into their computer (with permission)

## Updating Installers

When Claude Code updates:

1. The installers will automatically get the latest version (they use npm)
2. You don't need to rebuild unless you change installer features
3. Users can update anytime with: `npm update -g @anthropic-ai/claude-code`

## Success Metrics

Track how well your distribution works:

- How many friends successfully installed?
- What were the most common issues?
- How long did it take on average?
- What questions came up most?

Use this feedback to improve your documentation and process!
