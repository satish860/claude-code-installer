#!/bin/bash
# Build script for Claude Code .pkg installer (macOS)

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Building Claude Code .pkg Installer...${NC}"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}[ERROR] This script must be run on macOS${NC}"
    exit 1
fi

# Create necessary directories
echo -e "${CYAN}[STEP] Creating build directories...${NC}"
mkdir -p build/root/usr/local/bin
mkdir -p build/scripts

# Copy installation script
echo -e "${CYAN}[STEP] Copying installation script...${NC}"
cp install-claude-code.sh build/root/usr/local/bin/
chmod +x build/root/usr/local/bin/install-claude-code.sh

# Create postinstall script
echo -e "${CYAN}[STEP] Creating postinstall script...${NC}"
cat > build/scripts/postinstall << 'EOF'
#!/bin/bash

# Run the installer
/usr/local/bin/install-claude-code.sh --silent

# Clean up
rm -f /usr/local/bin/install-claude-code.sh

exit 0
EOF

chmod +x build/scripts/postinstall

# Build the package
echo -e "${CYAN}[STEP] Building package...${NC}"

pkgbuild --root build/root \
         --scripts build/scripts \
         --identifier com.claudecode.installer \
         --version 1.0.0 \
         --install-location / \
         build/ClaudeCodeInstaller-component.pkg

# Create product archive with welcome text
echo -e "${CYAN}[STEP] Creating product archive...${NC}"

# Create distribution XML
cat > build/distribution.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="1">
    <title>Claude Code</title>
    <organization>com.claudecode</organization>
    <domains enable_localSystem="true"/>
    <options customize="never" require-scripts="false" hostArchitectures="x86_64,arm64"/>

    <welcome file="welcome.html" mime-type="text/html"/>
    <conclusion file="conclusion.html" mime-type="text/html"/>

    <pkg-ref id="com.claudecode.installer" version="1.0.0">ClaudeCodeInstaller-component.pkg</pkg-ref>

    <choices-outline>
        <line choice="default">
            <line choice="com.claudecode.installer"/>
        </line>
    </choices-outline>

    <choice id="default"/>
    <choice id="com.claudecode.installer" visible="false">
        <pkg-ref id="com.claudecode.installer"/>
    </choice>
</installer-gui-script>
EOF

# Create welcome page
cat > build/welcome.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
        h1 { color: #333; }
        p { color: #666; line-height: 1.6; }
    </style>
</head>
<body>
    <h1>Welcome to Claude Code Installer</h1>
    <p>This installer will set up Claude Code on your Mac.</p>
    <p>The installer will:</p>
    <ul>
        <li>Check for Node.js (version 18 or higher)</li>
        <li>Install Node.js if needed (via Homebrew)</li>
        <li>Install Claude Code globally</li>
    </ul>
    <p><strong>Note:</strong> This installer requires an internet connection.</p>
</body>
</html>
EOF

# Create conclusion page
cat > build/conclusion.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
        h1 { color: #333; }
        p { color: #666; line-height: 1.6; }
        code { background: #f5f5f5; padding: 2px 6px; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>Installation Complete!</h1>
    <p>Claude Code has been installed successfully.</p>
    <p><strong>Next steps:</strong></p>
    <ol>
        <li>Open Terminal</li>
        <li>Navigate to your project directory</li>
        <li>Run: <code>claude</code></li>
        <li>Follow the authentication prompts</li>
    </ol>
    <p>For more information, visit: <a href="https://claude.com/product/claude-code">https://claude.com/product/claude-code</a></p>
</body>
</html>
EOF

# Build the final product
productbuild --distribution build/distribution.xml \
             --package-path build \
             --resources build \
             ClaudeCodeInstaller.pkg

# Clean up
echo -e "${CYAN}[STEP] Cleaning up...${NC}"
rm -rf build

echo ""
echo -e "${GREEN}[OK] .pkg installer built successfully!${NC}"
echo -e "${GREEN}Output: ClaudeCodeInstaller.pkg${NC}"
echo ""
echo -e "${YELLOW}[INFO] To sign the package (optional):${NC}"
echo "  productsign --sign 'Developer ID Installer: Your Name' \\"
echo "              ClaudeCodeInstaller.pkg ClaudeCodeInstaller-signed.pkg"
echo ""
