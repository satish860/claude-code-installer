#!/bin/bash
# Claude Code Installer for macOS

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SILENT=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --silent)
            SILENT=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

print_step() {
    if [ "$SILENT" = false ]; then
        echo -e "\n${CYAN}${BOLD}[STEP]${NC} $1"
    fi
}

print_success() {
    if [ "$SILENT" = false ]; then
        echo -e "${GREEN}[OK]${NC} $1"
    fi
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

print_info() {
    if [ "$SILENT" = false ]; then
        echo -e "${YELLOW}[INFO]${NC} $1"
    fi
}

check_node_installed() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 18 ]; then
            return 0
        else
            return 1
        fi
    else
        return 2
    fi
}

install_homebrew() {
    print_step "Installing Homebrew..."

    if command -v brew &> /dev/null; then
        print_success "Homebrew is already installed"
        return 0
    fi

    print_info "Installing Homebrew (this may take a few minutes)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed successfully"
}

install_nodejs() {
    print_step "Installing Node.js..."

    # Try Homebrew first
    if command -v brew &> /dev/null; then
        print_info "Installing Node.js via Homebrew..."
        brew install node@20

        # Link it
        brew link node@20

        print_success "Node.js installed successfully"
        return 0
    else
        # Install Homebrew first
        install_homebrew
        if [ $? -eq 0 ]; then
            brew install node@20
            brew link node@20
            print_success "Node.js installed successfully"
            return 0
        else
            print_error "Failed to install Homebrew"
            return 1
        fi
    fi
}

install_claude_code() {
    print_step "Installing Claude Code..."

    print_info "Running: npm install -g @anthropic-ai/claude-code"

    if npm install -g @anthropic-ai/claude-code; then
        print_success "Claude Code installed successfully"
        return 0
    else
        print_error "Failed to install Claude Code"
        return 1
    fi
}

verify_installation() {
    if command -v claude &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Main installation process
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Claude Code Installer for macOS${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if running as root (not recommended)
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this installer as root (sudo)"
    exit 1
fi

# Check Node.js installation
print_step "Checking Node.js installation..."
check_node_installed
NODE_STATUS=$?

case $NODE_STATUS in
    0)
        NODE_VER=$(node --version)
        print_success "Node.js $NODE_VER is already installed"
        ;;
    1)
        NODE_VER=$(node --version)
        print_info "Node.js $NODE_VER is installed but version 18+ is required"
        if [ "$SILENT" = false ]; then
            read -p "Would you like to upgrade Node.js? (Y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if ! install_nodejs; then
                    print_error "Installation aborted"
                    exit 1
                fi
            else
                print_error "Node.js 18+ is required. Installation aborted."
                exit 1
            fi
        else
            if ! install_nodejs; then
                print_error "Installation aborted"
                exit 1
            fi
        fi
        ;;
    2)
        print_info "Node.js is not installed"
        if ! install_nodejs; then
            print_error "Installation aborted"
            exit 1
        fi
        ;;
esac

# Install Claude Code
if ! install_claude_code; then
    print_error "Installation aborted"
    exit 1
fi

# Verify installation
print_step "Verifying installation..."
sleep 2

if verify_installation; then
    print_success "Installation verified successfully!"
else
    print_info "Installation completed but verification failed"
    print_info "Please restart your terminal and try running 'claude --version'"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Open a new Terminal window"
echo "2. Navigate to your project directory"
echo "3. Run: claude"
echo "4. Follow the authentication prompts"
echo ""

if [ "$SILENT" = false ]; then
    read -p "Press Enter to exit..."
fi
