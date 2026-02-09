#!/bin/bash
# Compound Engineering Installer
# Installs the parallel Claude Code workflow orchestrator

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="$HOME/.ce-orchestrator"
REPO_URL="https://github.com/cardinalpointstudio/CEOrchestrator.git"

echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Compound Engineering Installer                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Check dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"

check_dep() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}✗ $1 not found${NC}"
        echo -e "  Install: $2"
        return 1
    else
        echo -e "${GREEN}✓ $1${NC}"
        return 0
    fi
}

MISSING=0
check_dep "bun" "https://bun.sh" || MISSING=1
check_dep "tmux" "brew install tmux / apt install tmux" || MISSING=1
check_dep "claude" "https://claude.com/code" || MISSING=1
check_dep "gh" "https://cli.github.com" || MISSING=1
check_dep "git" "https://git-scm.com" || MISSING=1

if [ $MISSING -eq 1 ]; then
    echo ""
    echo -e "${RED}Please install missing dependencies and re-run.${NC}"
    exit 1
fi

echo ""

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Updating existing installation...${NC}"
    cd "$INSTALL_DIR"
    git pull --quiet
else
    echo -e "${YELLOW}Cloning repository...${NC}"
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/orchestrate.ts"
chmod +x "$INSTALL_DIR/compound-start.sh"

echo -e "${GREEN}✓ Scripts installed${NC}"

# Add to PATH
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "ce-orchestrator" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# Compound Engineering" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
        echo -e "${GREEN}✓ Added to PATH in $SHELL_RC${NC}"
    else
        echo -e "${GREEN}✓ Already in PATH${NC}"
    fi
fi

# Create alias for easy access
ALIAS_CMD="alias ce='$INSTALL_DIR/compound-start.sh'"
if [ -n "$SHELL_RC" ]; then
    if ! grep -q "alias ce=" "$SHELL_RC" 2>/dev/null; then
        echo "$ALIAS_CMD" >> "$SHELL_RC"
        echo -e "${GREEN}✓ Created 'ce' alias${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Installation Complete!                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BLUE}Quick Start:${NC}"
echo ""
echo "    1. Restart your terminal or run:"
echo -e "       ${YELLOW}source $SHELL_RC${NC}"
echo ""
echo "    2. Navigate to your project:"
echo -e "       ${YELLOW}cd ~/my-project${NC}"
echo ""
echo "    3. Start a session:"
echo -e "       ${YELLOW}ce${NC}  or  ${YELLOW}compound-start.sh${NC}"
echo ""
echo -e "  ${BLUE}Documentation:${NC} $INSTALL_DIR/README.md"
echo ""
