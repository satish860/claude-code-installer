# Contributing to Claude Code Installers

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in [Issues](../../issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - System information (OS, version)
   - Screenshots if applicable

### Proposing Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test thoroughly on both Windows and macOS (if applicable)
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

## Development Setup

### Prerequisites

**Windows Development:**
- Windows 10 or later
- PowerShell 5.1+
- WiX Toolset v3.11+: `winget install WiXToolset.WiX`
- Git for Windows

**macOS Development:**
- macOS 10.15 (Catalina) or later
- Xcode Command Line Tools: `xcode-select --install`
- Git

### Local Testing

**Test Windows installer:**
```powershell
cd windows
.\install-claude-code.ps1
```

**Test macOS installer:**
```bash
cd mac
chmod +x install-claude-code.sh
./install-claude-code.sh
```

**Build Windows MSI:**
```powershell
cd windows
.\build-msi.ps1
```

**Build macOS PKG:**
```bash
cd mac
chmod +x build-pkg.sh
./build-pkg.sh
```

## Code Style Guidelines

### PowerShell Scripts

- Use PascalCase for function names
- Use clear, descriptive variable names
- Add comments for complex logic
- Include error handling with try/catch
- Use `Write-Host` with color coding for user feedback
- Follow verb-noun naming convention

### Shell Scripts

- Use snake_case for function names
- Add shebang: `#!/bin/bash`
- Use `set -e` for error handling
- Include color-coded output
- Quote variables to prevent word splitting
- Test with both bash and zsh

### General Guidelines

- Keep scripts readable and well-commented
- Test on clean systems when possible
- Verify Node.js version checking works
- Ensure error messages are helpful
- Maintain backwards compatibility

## Testing Checklist

Before submitting a PR, verify:

### Windows Testing
- [ ] Script runs on Windows 10
- [ ] Script runs on Windows 11
- [ ] Works with Node.js already installed
- [ ] Works without Node.js installed
- [ ] Works with old Node.js version (< 18)
- [ ] MSI builds successfully
- [ ] MSI installs without errors
- [ ] Claude command works after installation
- [ ] Script handles interrupted installation
- [ ] Error messages are clear

### macOS Testing
- [ ] Script runs on Intel Mac
- [ ] Script runs on Apple Silicon Mac
- [ ] Works with Node.js already installed
- [ ] Works without Node.js installed
- [ ] Works without Homebrew installed
- [ ] PKG builds successfully
- [ ] PKG installs without errors
- [ ] Claude command works after installation
- [ ] Script handles interrupted installation
- [ ] Error messages are clear

## CI/CD Testing

All pull requests automatically trigger:
- Windows MSI build
- macOS PKG build
- Linting and validation

Ensure all checks pass before requesting review.

## Documentation

When making changes, update:
- README.md if user-facing features change
- QUICK_START.md if installation steps change
- Inline comments in scripts
- This CONTRIBUTING.md if development process changes

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
feat: Add support for custom Node.js version
fix: Resolve PATH issue on Windows 11
docs: Update installation instructions
chore: Update WiX configuration
test: Add validation for Node.js detection
```

Prefixes:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `test:` - Testing improvements
- `refactor:` - Code refactoring

## Pull Request Process

1. Update documentation as needed
2. Test on both Windows and macOS if applicable
3. Ensure CI/CD checks pass
4. Request review from maintainers
5. Address review feedback
6. Maintainer will merge when approved

## Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- Linux support (deb/rpm packages)
- Automated uninstaller scripts
- Better error handling and recovery
- Installation progress indicators
- Offline installation support

### Medium Priority
- Code signing automation
- Homebrew tap for macOS
- Chocolatey package for Windows
- Multi-language support
- GUI installer option

### Nice to Have
- Custom Node.js version selection
- Installation telemetry (opt-in)
- Auto-update mechanism
- Silent installation improvements
- Installation verification tests

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the project
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information
- Other unprofessional conduct

## Questions?

- Open a [Discussion](../../discussions) for questions
- Check [existing Issues](../../issues) for similar questions
- Review documentation in README.md and QUICK_START.md

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes (for significant contributions)
- Project documentation

Thank you for helping make Claude Code more accessible!
