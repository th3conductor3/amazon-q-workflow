#!/bin/bash

# Secrets Manager for Amazon Q Workflow
# This script helps manage your offline secrets securely

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
SECRETS_DIR="$HOME/.amazon-q-workflow/secrets"
SECRETS_FILE="$SECRETS_DIR/workflow_secrets.md"
SECRETS_TEMPLATE="/home/kali/amazon-q-workflow/docs/SECRETS_TEMPLATE.md"

# Create secrets directory with restricted permissions
setup_secrets_dir() {
    echo -e "${BLUE}Setting up secure secrets directory...${NC}"
    
    # Create directory with restricted permissions
    mkdir -p "$SECRETS_DIR"
    chmod 700 "$SECRETS_DIR"
    
    echo -e "${GREEN}Secrets directory created with restricted permissions${NC}"
}

# Initialize new secrets file
init_secrets() {
    if [ -f "$SECRETS_FILE" ]; then
        echo -e "${RED}Secrets file already exists!${NC}"
        echo -e "${YELLOW}Use 'update' command to modify existing secrets${NC}"
        return 1
    fi
    
    # Copy template and set restricted permissions
    cp "$SECRETS_TEMPLATE" "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    
    # Update the date in the file
    sed -i "s/<update_date>/$(date '+%Y-%m-%d')/" "$SECRETS_FILE"
    
    echo -e "${GREEN}Secrets file initialized!${NC}"
    echo -e "${YELLOW}Edit your secrets file at: $SECRETS_FILE${NC}"
    echo -e "${YELLOW}File permissions are set to user-only read/write${NC}"
}

# Backup secrets
backup_secrets() {
    if [ ! -f "$SECRETS_FILE" ]; then
        echo -e "${RED}No secrets file found to backup!${NC}"
        return 1
    fi
    
    BACKUP_FILE="$SECRETS_DIR/workflow_secrets_backup_$(date '+%Y%m%d_%H%M%S').md"
    cp "$SECRETS_FILE" "$BACKUP_FILE"
    chmod 600 "$BACKUP_FILE"
    
    echo -e "${GREEN}Secrets backed up to: $BACKUP_FILE${NC}"
}

# List all secret backups
list_backups() {
    echo -e "${BLUE}Available secrets backups:${NC}"
    ls -l "$SECRETS_DIR" | grep "workflow_secrets_backup_"
}

# Check secrets file status
check_status() {
    echo -e "${BLUE}Checking secrets status...${NC}"
    
    if [ -d "$SECRETS_DIR" ]; then
        echo -e "${GREEN}✓${NC} Secrets directory exists"
        ls -ld "$SECRETS_DIR"
    else
        echo -e "${RED}✗${NC} Secrets directory not found"
    fi
    
    if [ -f "$SECRETS_FILE" ]; then
        echo -e "${GREEN}✓${NC} Secrets file exists"
        ls -l "$SECRETS_FILE"
        echo -e "${YELLOW}Last modified: $(stat -c %y "$SECRETS_FILE")${NC}"
    else
        echo -e "${RED}✗${NC} Secrets file not found"
    fi
}

# Display help
show_help() {
    echo -e "${BLUE}Amazon Q Workflow Secrets Manager${NC}"
    echo -e "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  init     - Initialize new secrets file"
    echo "  backup   - Create backup of current secrets"
    echo "  list     - List available backups"
    echo "  status   - Check secrets file status"
    echo "  help     - Show this help message"
}

# Main command handler
case "$1" in
    init)
        setup_secrets_dir
        init_secrets
        ;;
    backup)
        backup_secrets
        ;;
    list)
        list_backups
        ;;
    status)
        check_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
