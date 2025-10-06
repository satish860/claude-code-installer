# Quick Start Guide for Claude Code

## For Non-Technical Users

### Windows Users

#### Option 1: Use the Batch File (Easiest)
1. Find the file `Install-Claude-Code.bat` in the `windows` folder
2. Double-click it
3. If you see a security warning, click "More info" then "Run anyway"
4. Follow the on-screen instructions
5. When complete, open PowerShell:
   - Press `Windows Key + X`
   - Click "Windows PowerShell" or "Terminal"
6. Type `claude` and press Enter

#### Option 2: Use the MSI Installer
1. Find the file `ClaudeCodeInstaller.msi`
2. Double-click it
3. Click "Next" through the installation wizard
4. When complete, open PowerShell (see step 5 above)
5. Type `claude` and press Enter

### Mac Users

1. Find the file `ClaudeCodeInstaller.pkg`
2. Double-click it
3. If you see "can't be opened because it is from an unidentified developer":
   - Open System Preferences
   - Go to Security & Privacy
   - Click "Open Anyway"
4. Follow the installation wizard
5. When complete, open Terminal:
   - Press `Command + Space`
   - Type "Terminal" and press Enter
6. Type `claude` and press Enter

## First Time Setup

After running `claude` for the first time:

1. You'll see a welcome message
2. Choose your authentication method:
   - **Claude Console** (recommended): Follow the link to log in
   - **Claude.ai account**: Log in with your Pro/Max account
3. Once authenticated, you're ready to go!

## Using Claude Code

### Basic Usage

```bash
# Start Claude in your project
cd path/to/your/project
claude
```

### Common Commands

Once Claude is running:
- Type your questions or requests naturally
- Claude can help with:
  - Writing code
  - Debugging
  - Explaining code
  - Refactoring
  - And much more!

### Example Session

```
$ claude
> Help me create a Python script to organize files by type

Claude will then help you create and refine the script!
```

## Getting Help

### Within Claude
- Type `/help` to see available commands
- Type your question naturally

### Need More Help?
- Official docs: https://docs.claude.com/claude-code
- GitHub: https://github.com/anthropics/claude-code

## Common Issues

### "claude: command not found"
**Solution:** Restart your terminal window. The PATH wasn't updated yet.

### "Node.js installation failed"
**Solution:**
- Check your internet connection
- Try running the installer again
- On Windows: Run as Administrator (right-click > Run as administrator)

### "npm install failed"
**Solution:**
- Check your internet connection
- Try running: `npm install -g @anthropic-ai/claude-code` manually

### Installation takes a long time
**Normal!** Node.js is a large download (50-100MB). The installation may take 5-10 minutes depending on your internet speed.

## Uninstalling

### Windows
```powershell
# Open PowerShell and run:
npm uninstall -g @anthropic-ai/claude-code
```

### Mac
```bash
# Open Terminal and run:
npm uninstall -g @anthropic-ai/claude-code
```

To also remove Node.js:
- **Windows**: Go to Settings > Apps > Node.js > Uninstall
- **Mac**: `brew uninstall node@20`

## Tips for Non-Technical Users

1. **Don't be afraid to restart**: If something doesn't work, close and reopen your terminal
2. **Check for typos**: Commands are case-sensitive
3. **Internet required**: Claude Code needs an internet connection to work
4. **Be patient**: First-time setup and large operations may take a few minutes
5. **Ask Claude**: Once installed, Claude can help you learn how to use Claude Code!

## What If Nothing Works?

1. Make sure you have an internet connection
2. Restart your computer
3. Try the installation again
4. Ask a tech-savvy friend to help with the error messages
5. Share the error message when seeking help

---

**Remember:** The hardest part is the installation. Once it's set up, using Claude Code is as simple as having a conversation!
