#!/bin/bash

# Setup script for Amazon Q Enhanced Workflow

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Amazon Q Enhanced Workflow Setup ===${NC}"
echo ""

# Check for required commands
check_requirements() {
    local missing_deps=0
    
    echo -e "${BLUE}Checking requirements...${NC}"
    
    # Check for jq
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${RED}Missing requirement: jq${NC}"
        echo -e "${YELLOW}Please install jq:${NC}"
        echo "  sudo apt-get install jq  # Debian/Ubuntu"
        echo "  sudo yum install jq      # RHEL/CentOS"
        echo "  brew install jq          # macOS"
        missing_deps=1
    fi
    
    # Check for curl
    if ! command -v curl >/dev/null 2>&1; then
        echo -e "${RED}Missing requirement: curl${NC}"
        echo -e "${YELLOW}Please install curl:${NC}"
        echo "  sudo apt-get install curl  # Debian/Ubuntu"
        echo "  sudo yum install curl      # RHEL/CentOS"
        echo "  brew install curl          # macOS"
        missing_deps=1
    fi
    
    # Check for Amazon Q CLI
    if ! command -v q >/dev/null 2>&1; then
        echo -e "${RED}Missing requirement: Amazon Q CLI${NC}"
        echo -e "${YELLOW}Please install the Amazon Q CLI before continuing${NC}"
        missing_deps=1
    fi
    
    if [ $missing_deps -eq 1 ]; then
        echo -e "${RED}Please install missing requirements and run setup again${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}All requirements satisfied${NC}"
    echo ""
}

# Configuration
CONFIG_DIR="$HOME/.amazon-q-workflow"
SCRIPTS_DIR="$CONFIG_DIR/scripts"
DOCS_DIR="$CONFIG_DIR/docs"
BIN_DIR="$HOME/.local/bin"

# Check requirements first
check_requirements

# Create directories
echo -e "${YELLOW}Creating configuration directories...${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$DOCS_DIR"
mkdir -p "$BIN_DIR"

# Copy scripts
echo -e "${YELLOW}Installing scripts...${NC}"
cp -v ./scripts/q-workflow.sh "$SCRIPTS_DIR/"
cp -v ./scripts/q-startup-check.sh "$SCRIPTS_DIR/"
cp -v ./scripts/q-enhanced "$SCRIPTS_DIR/"
cp -v ./scripts/installation-check.sh "$SCRIPTS_DIR/"
chmod +x "$SCRIPTS_DIR"/*.sh "$SCRIPTS_DIR/q-enhanced"

# Create symbolic links
echo -e "${YELLOW}Creating symbolic links...${NC}"
ln -sf "$SCRIPTS_DIR/q-workflow.sh" "$BIN_DIR/q-workflow"
ln -sf "$SCRIPTS_DIR/q-enhanced" "$BIN_DIR/q-enhanced"
ln -sf "$SCRIPTS_DIR/installation-check.sh" "$BIN_DIR/q-check-install"

# Set up shell integration
SHELL_RC="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

# Add alias to shell configuration
if ! grep -q "alias q=" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# Amazon Q Enhanced Workflow" >> "$SHELL_RC"
    echo "alias q='q-enhanced'" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${GREEN}Added Amazon Q Enhanced Workflow to shell configuration${NC}"
fi

# Copy documentation
echo -e "${YELLOW}Installing documentation...${NC}"
cp -r ./docs/* "$DOCS_DIR/"

# Initialize memory log if it doesn't exist
MEMORY_LOG="$CONFIG_DIR/amazon_q_project_memory.log"
if [ ! -f "$MEMORY_LOG" ]; then
    echo -e "${YELLOW}Initializing project memory log...${NC}"
    cat > "$MEMORY_LOG" << EOF
# Amazon Q Project Memory Log
# This file maintains a persistent record of projects and conversations
# Created: $(date)

## PROJECT HISTORY

### Current Date: $(date +%Y-%m-%d)

#### RECENT PROJECTS:
- Amazon Q Enhanced Workflow ($(date +%Y-%m-%d))
  - Installed Amazon Q Enhanced Workflow system
  - Set up persistent memory and multi-AI collaboration

## CONVERSATION NOTES

### $(date +%Y-%m-%d)
- Set up Amazon Q Enhanced Workflow system
- Initialized persistent memory log

## HOW TO USE THIS FILE

This file serves as a persistent memory for Amazon Q. When starting a new session:
1. Reference this file to remind Amazon Q about previous projects
2. Update this file with new project information
3. Use the q-workflow command to maintain organization
EOF
fi

# Set up GitHub MCP if not already configured
if [ ! -f "$HOME/.github-mcp/config.json" ]; then
    echo -e "${YELLOW}Setting up GitHub MCP server...${NC}"
    ./mcp-servers/github/register_github_mcp.sh
fi

# Run installation checklist
echo -e "${BLUE}Running installation checklist...${NC}"
"$SCRIPTS_DIR/installation-check.sh"

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo -e "1. Start Amazon Q with enhanced features:"
echo -e "   ${YELLOW}q${NC}"
echo ""
echo -e "2. Use workflow commands:"
echo -e "   ${YELLOW}q-workflow help${NC}"
echo ""
echo -e "3. Check installation status:"
echo -e "   ${YELLOW}q-check-install${NC}"
echo ""
echo -e "${YELLOW}Note: You may need to restart your shell or run 'source $SHELL_RC'${NC}"
echo -e "${YELLOW}to use the 'q' command with the enhanced features.${NC}"
