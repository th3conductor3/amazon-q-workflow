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

# Configuration
CONFIG_DIR="$HOME/.amazon-q-workflow"
SCRIPTS_DIR="$HOME/.amazon-q-workflow/scripts"
MEMORY_LOG="$CONFIG_DIR/amazon_q_project_memory.log"
SHARED_MEMORY="$CONFIG_DIR/shared_ai_memory.txt"

# Create directories
echo -e "${YELLOW}Creating configuration directories...${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$SCRIPTS_DIR"

# Copy scripts
echo -e "${YELLOW}Installing scripts...${NC}"
cp -v ./scripts/q-workflow.sh "$SCRIPTS_DIR/"
chmod +x "$SCRIPTS_DIR/q-workflow.sh"

# Create symbolic link in /usr/local/bin if possible
if [ -w /usr/local/bin ]; then
  echo -e "${YELLOW}Creating symbolic link in /usr/local/bin...${NC}"
  ln -sf "$SCRIPTS_DIR/q-workflow.sh" /usr/local/bin/q-workflow
  echo -e "${GREEN}You can now use 'q-workflow' command from anywhere.${NC}"
else
  echo -e "${YELLOW}Cannot create symbolic link in /usr/local/bin (requires sudo).${NC}"
  echo -e "${YELLOW}You can still use the script from its installed location.${NC}"
fi

# Initialize memory log if it doesn't exist
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
3. Use the q-workflow.sh script to maintain organization

## PROJECT DETAILS

### Amazon Q Enhanced Workflow
- **Date**: $(date +%Y-%m-%d)
- **Purpose**: Enable persistent memory and multi-AI collaboration for Amazon Q
- **Components**:
  - q-workflow.sh (main script for managing memory and collaboration)
  - amazon_q_project_memory.log (persistent memory log)
  - shared_ai_memory.txt (shared context file)
- **Status**: Initial setup complete
EOF
fi

# Initialize shared memory file if it doesn't exist
if [ ! -f "$SHARED_MEMORY" ]; then
  echo -e "${YELLOW}Initializing shared memory file...${NC}"
  cat > "$SHARED_MEMORY" << EOF
# Shared AI Memory
# This file serves as a shared memory space between Amazon Q and other AI assistants

CURRENT TASK: None
LAST UPDATED: $(date)

NOTES:
- Amazon Q is optimized for AWS services, system operations, and file management
- Other AI assistants may have different strengths and capabilities
- Use this file to pass information between AI assistants

CURRENT CONTEXT:
Working in $(uname -s) environment at $HOME
EOF
fi

# Create bash completion if possible
if [ -d /etc/bash_completion.d ] && [ -w /etc/bash_completion.d ]; then
  echo -e "${YELLOW}Setting up bash completion...${NC}"
  cat > /etc/bash_completion.d/q-workflow << EOF
_q_workflow() {
    local cur prev opts
    COMPREPLY=()
    cur="\${COMP_WORDS[COMP_CWORD]}"
    prev="\${COMP_WORDS[COMP_CWORD-1]}"
    opts="save read project update note memory start-q help version"

    COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
    return 0
}
complete -F _q_workflow q-workflow
EOF
  echo -e "${GREEN}Bash completion installed.${NC}"
else
  echo -e "${YELLOW}Cannot install bash completion (requires sudo).${NC}"
fi

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo -e "  ${YELLOW}$SCRIPTS_DIR/q-workflow.sh help${NC}  # Show help"
if [ -w /usr/local/bin ]; then
  echo -e "  ${YELLOW}q-workflow help${NC}                # Show help (using the global command)"
fi
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Start using Amazon Q with enhanced workflow: ${YELLOW}$SCRIPTS_DIR/q-workflow.sh start-q${NC}"
echo -e "2. Log your first project: ${YELLOW}$SCRIPTS_DIR/q-workflow.sh project \"My Project\" \"Description\"${NC}"
echo -e "3. View your project memory: ${YELLOW}$SCRIPTS_DIR/q-workflow.sh memory${NC}"
echo ""
