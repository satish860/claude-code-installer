#!/bin/bash
# Release Creation Script
# Creates a new version tag and pushes to GitHub to trigger release workflow

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "\n${CYAN}${BOLD}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Parse arguments
DRY_RUN=false
VERSION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Usage: $0 --version <version> [--dry-run]"
            echo "Example: $0 --version 1.0.0"
            exit 1
            ;;
    esac
done

# Validate version
if [ -z "$VERSION" ]; then
    print_error "Version is required!"
    echo "Usage: $0 --version <version> [--dry-run]"
    echo "Example: $0 --version 1.0.0"
    exit 1
fi

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format! Use semantic versioning: X.Y.Z"
    echo "Example: 1.0.0"
    exit 1
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Release Creation Tool${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

TAG="v$VERSION"

# Check if we're in a git repository
print_step "Checking git repository..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    print_success "Git repository detected"
else
    print_error "Not a git repository!"
    exit 1
fi

# Check for uncommitted changes
print_step "Checking for uncommitted changes..."
if [ -n "$(git status --porcelain)" ]; then
    print_error "You have uncommitted changes:"
    git status --short
    echo ""
    print_info "Please commit or stash your changes before creating a release."
    exit 1
fi
print_success "Working directory is clean"

# Check if tag already exists
print_step "Checking if tag exists..."
if git rev-parse "$TAG" >/dev/null 2>&1; then
    print_error "Tag $TAG already exists!"
    print_info "Use 'git tag -d $TAG' to delete it locally if needed."
    exit 1
fi
print_success "Tag $TAG is available"

# Fetch latest changes
print_step "Fetching latest changes from remote..."
git fetch --tags
print_success "Fetched latest changes"

# Check if we're on main branch
print_step "Checking current branch..."
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    print_info "You are on branch: $CURRENT_BRANCH"
    print_info "Releases are typically created from 'main' or 'master' branch."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Release cancelled."
        exit 0
    fi
fi
print_success "On branch: $CURRENT_BRANCH"

# Update version in WiX file
print_step "Updating version in WiX installer configuration..."
WIX_FILE="windows/claude-code-installer.wxs"
if [ -f "$WIX_FILE" ]; then
    sed -i.bak "s/Version=\"[0-9.]*\"/Version=\"$VERSION.0\"/" "$WIX_FILE"
    rm -f "$WIX_FILE.bak"
    print_success "Updated $WIX_FILE"

    if [ "$DRY_RUN" = false ]; then
        git add "$WIX_FILE"
        git commit -m "chore: Bump version to $VERSION"
        print_success "Committed version update"
    fi
else
    print_info "WiX file not found, skipping version update"
fi

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  DRY RUN - No changes made${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    print_info "Would create tag: $TAG"
    print_info "Would push to remote"
    print_info "Remove --dry-run flag to actually create the release"
    exit 0
fi

# Create the tag
print_step "Creating tag $TAG..."
git tag -a "$TAG" -m "Release $TAG"
print_success "Created tag $TAG"

# Push the tag
print_step "Pushing tag to remote..."
if git push origin "$TAG"; then
    print_success "Pushed tag to remote"
else
    print_error "Failed to push tag!"
    print_info "You can manually push with: git push origin $TAG"
    print_info "Or delete the local tag with: git tag -d $TAG"
    exit 1
fi

# Push the version update commit if any
print_step "Pushing version update commit..."
if git push; then
    print_success "Pushed commits to remote"
else
    print_error "Failed to push commits!"
    print_info "The tag was pushed, but the version commit was not."
    print_info "Manually push with: git push"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Release Created Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
print_success "Tag: $TAG"
print_info "GitHub Actions will now build the installers and create a release."
print_info "Check progress at: https://github.com/satish860/claude-code-installer/actions"
print_info "Release will be available at: https://github.com/satish860/claude-code-installer/releases/tag/$TAG"
echo ""
