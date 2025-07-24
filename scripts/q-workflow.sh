#!/bin/bash

# Amazon Q Enhanced Workflow Script
# This script provides persistent memory and multi-AI collaboration for Amazon Q

# Configuration
CONFIG_DIR="$HOME/.amazon-q-workflow"
MEMORY_LOG="$CONFIG_DIR/amazon_q_project_memory.log"
SHARED_MEMORY="$CONFIG_DIR/shared_ai_memory.txt"
VERSION="1.0.0"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Display header
display_header() {
  echo -e "${BLUE}=== Amazon Q Enhanced Workflow v${VERSION} ===${NC}"
  echo -e "${GREEN}1. Persistent memory across Amazon Q sessions${NC}"
  echo -e "${GREEN}2. Multi-AI collaboration capabilities${NC}"
  echo -e "${GREEN}3. Standardized project management${NC}"
  echo ""
}

# Function to save content to a file that can be shared between assistants
save_to_shared_memory() {
  echo "$1" > "$SHARED_MEMORY"
  echo -e "${GREEN}Content saved to shared memory file.${NC}"
}

# Function to read from shared memory
read_from_shared_memory() {
  if [ -f "$SHARED_MEMORY" ]; then
    cat "$SHARED_MEMORY"
  else
    echo -e "${YELLOW}No shared memory file found.${NC}"
  fi
}

# Function to log a new project entry
log_project() {
  local project_name="$1"
  local project_desc="$2"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  
  # Create the memory log if it doesn't exist
  if [ ! -f "$MEMORY_LOG" ]; then
    echo "# Amazon Q Project Memory Log" > "$MEMORY_LOG"
    echo "# This file maintains a persistent record of projects and conversations" >> "$MEMORY_LOG"
    echo "# Created: $(date)" >> "$MEMORY_LOG"
    echo "" >> "$MEMORY_LOG"
    echo "## PROJECT HISTORY" >> "$MEMORY_LOG"
    echo "" >> "$MEMORY_LOG"
  fi
  
  echo -e "\n### New Project: $project_name ($timestamp)" >> "$MEMORY_LOG"
  echo -e "- Description: $project_desc" >> "$MEMORY_LOG"
  echo -e "- Status: Started\n" >> "$MEMORY_LOG"
  
  echo -e "${GREEN}Project '${BLUE}$project_name${GREEN}' logged to memory file.${NC}"
}

# Function to update a project status
update_project() {
  local project_name="$1"
  local status_update="$2"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  
  echo -e "\n### Update to Project: $project_name ($timestamp)" >> "$MEMORY_LOG"
  echo -e "- Status: $status_update\n" >> "$MEMORY_LOG"
  
  echo -e "${GREEN}Project '${BLUE}$project_name${GREEN}' status updated in memory file.${NC}"
}

# Function to log a conversation note
log_conversation() {
  local note="$1"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  
  echo -e "\n### Conversation Note ($timestamp)" >> "$MEMORY_LOG"
  echo -e "- $note\n" >> "$MEMORY_LOG"
  
  echo -e "${GREEN}Conversation note logged to memory file.${NC}"
}

# Function to display the memory log
view_memory() {
  if [ -f "$MEMORY_LOG" ]; then
    cat "$MEMORY_LOG"
  else
    echo -e "${YELLOW}No memory log file found.${NC}"
  fi
}

# Function to start Amazon Q with memory context
start_q_with_memory() {
  if [ -f "$MEMORY_LOG" ]; then
    echo -e "${BLUE}Starting Amazon Q with memory context...${NC}"
    echo -e "${YELLOW}Remember to share relevant parts of your project history with Amazon Q.${NC}"
    echo -e "${YELLOW}You can view your project history with: ./q-workflow.sh memory${NC}"
    echo ""
    q
  else
    echo -e "${YELLOW}No memory log found. Starting Amazon Q without context...${NC}"
    q
  fi
}

# Function to display help
display_help() {
  echo -e "${BLUE}Amazon Q Enhanced Workflow - Usage Guide${NC}"
  echo ""
  echo -e "${GREEN}Commands:${NC}"
  echo -e "  ${YELLOW}./q-workflow.sh save \"your content here\"${NC}    # Save to shared memory"
  echo -e "  ${YELLOW}./q-workflow.sh read${NC}                        # Read from shared memory"
  echo -e "  ${YELLOW}./q-workflow.sh project \"name\" \"desc\"${NC}      # Log a new project"
  echo -e "  ${YELLOW}./q-workflow.sh update \"name\" \"status\"${NC}     # Update project status"
  echo -e "  ${YELLOW}./q-workflow.sh note \"conversation note\"${NC}    # Log a conversation note"
  echo -e "  ${YELLOW}./q-workflow.sh memory${NC}                      # View the memory log"
  echo -e "  ${YELLOW}./q-workflow.sh start-q${NC}                     # Start Amazon Q with memory context"
  echo -e "  ${YELLOW}./q-workflow.sh help${NC}                        # Display this help message"
  echo -e "  ${YELLOW}./q-workflow.sh version${NC}                     # Display version information"
}

# Display header
display_header

# Command handling
case "$1" in
  save)
    save_to_shared_memory "$2"
    ;;
  read)
    read_from_shared_memory
    ;;
  project)
    log_project "$2" "$3"
    ;;
  update)
    update_project "$2" "$3"
    ;;
  note)
    log_conversation "$2"
    ;;
  memory)
    view_memory
    ;;
  start-q)
    start_q_with_memory
    ;;
  help)
    display_help
    ;;
  version)
    echo -e "${BLUE}Amazon Q Enhanced Workflow v${VERSION}${NC}"
    ;;
  *)
    display_help
    ;;
esac
