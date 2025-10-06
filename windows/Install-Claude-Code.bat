@echo off
REM Simple batch file wrapper for Claude Code installation
REM This can be distributed as a standalone installer

echo Starting Claude Code installer...
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not available on this system.
    echo PowerShell is required to run this installer.
    pause
    exit /b 1
)

REM Run the PowerShell installation script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0install-claude-code.ps1"

REM Check if installation was successful
if %errorlevel% equ 0 (
    echo.
    echo Installation completed successfully!
) else (
    echo.
    echo Installation failed. Please check the error messages above.
)

pause
