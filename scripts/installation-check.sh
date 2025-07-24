#!/bin/bash

# Installation Checklist for Amazon Q Enhanced Workflow
# This script verifies all components are properly installed and configured

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECK_MARK="${GREEN}✓${NC}"
CROSS_MARK="${RED}✗${NC}"
INFO_MARK="${BLUE}ℹ${NC}"

# Configuration paths
CONFIG_DIR="$HOME/.amazon-q-workflow"
SCRIPTS_DIR="$CONFIG_DIR/scripts"
DOCS_DIR="$CONFIG_DIR/docs"
BIN_DIR="$HOME/.local/bin"
MEMORY_LOG="$CONFIG_DIR/amazon_q_project_memory.log"
GITHUB_MCP_CONFIG="$HOME/.github-mcp/config.json"

echo -e "${BLUE}=== Amazon Q Enhanced Workflow - Installation Checklist ===${NC}"
echo ""

# Function to check directory existence
check_directory() {
    local dir="$1"
    local name="$2"
    if [ -d "$dir" ]; then
        echo -e "${CHECK_MARK} $name directory exists: $dir"
        return 0
    else
        echo -e "${CROSS_MARK} $name directory missing: $dir"
        return 1
    fi
}

# Function to check file existence
check_file() {
    local file="$1"
    local name="$2"
    if [ -f "$file" ]; then
        echo -e "${CHECK_MARK} $name file exists: $file"
        return 0
    else
        echo -e "${CROSS_MARK} $name file missing: $file"
        return 1
    fi
}

# Function to check command availability
check_command() {
    local cmd="$1"
    local name="$2"
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${CHECK_MARK} $name command is available"
        return 0
    else
        echo -e "${CROSS_MARK} $name command is not available"
        return 1
    fi
}

# Function to check shell configuration
check_shell_config() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        if grep -q "alias q='q-enhanced'" "$config_file"; then
            echo -e "${CHECK_MARK} Shell configuration is properly set up"
            return 0
        else
            echo -e "${CROSS_MARK} Shell configuration needs updating"
            return 1
        fi
    else
        echo -e "${CROSS_MARK} Shell configuration file not found: $config_file"
        return 1
    fi
}

echo -e "${BLUE}1. Checking Directory Structure${NC}"
check_directory "$CONFIG_DIR" "Configuration"
check_directory "$SCRIPTS_DIR" "Scripts"
check_directory "$DOCS_DIR" "Documentation"
check_directory "$BIN_DIR" "Binary"
echo ""

echo -e "${BLUE}2. Checking Core Files${NC}"
check_file "$SCRIPTS_DIR/q-workflow.sh" "Workflow script"
check_file "$SCRIPTS_DIR/q-startup-check.sh" "Startup check script"
check_file "$SCRIPTS_DIR/q-enhanced" "Enhanced Q launcher"
check_file "$MEMORY_LOG" "Memory log"
echo ""

echo -e "${BLUE}3. Checking Commands${NC}"
check_command "q" "Amazon Q CLI"
check_command "q-workflow" "Workflow"
check_command "q-enhanced" "Enhanced Q"
check_command "jq" "JSON processor"
echo ""

echo -e "${BLUE}4. Checking Shell Integration${NC}"
if [ -f "$HOME/.zshrc" ]; then
    check_shell_config "$HOME/.zshrc"
else
    check_shell_config "$HOME/.bashrc"
fi
echo ""

echo -e "${BLUE}5. Checking GitHub MCP Integration${NC}"
if check_file "$GITHUB_MCP_CONFIG" "GitHub MCP configuration"; then
    # Verify GitHub configuration
    if [ -f "$GITHUB_MCP_CONFIG" ]; then
        username=$(jq -r '.github.username' "$GITHUB_MCP_CONFIG" 2>/dev/null)
        token=$(jq -r '.github.token' "$GITHUB_MCP_CONFIG" 2>/dev/null)
        if [ ! -z "$username" ] && [ "$username" != "null" ] && [ ! -z "$token" ] && [ "$token" != "null" ]; then
            echo -e "${CHECK_MARK} GitHub MCP is configured for user: $username"
            # Test GitHub API access
            api_status=$(curl -s -H "Authorization: token $token" \
                -w "%{http_code}" -o /dev/null \
                "https://api.github.com/user")
            if [ "$api_status" = "200" ]; then
                echo -e "${CHECK_MARK} GitHub API access is working"
            else
                echo -e "${CROSS_MARK} GitHub API access failed - token may need to be refreshed"
            fi
        else
            echo -e "${CROSS_MARK} GitHub MCP configuration is incomplete"
        fi
    fi
fi
echo ""

echo -e "${BLUE}6. Checking Documentation${NC}"
doc_count=$(find "$DOCS_DIR" -name "*.md" -type f | wc -l)
echo -e "${INFO_MARK} Found $doc_count documentation files"
if [ $doc_count -gt 0 ]; then
    echo "Available documentation:"
    find "$DOCS_DIR" -name "*.md" -type f -exec basename {} \; | sed 's/^/  - /'
fi
echo ""

# Summary
echo -e "${BLUE}=== Installation Summary ===${NC}"
echo -e "${INFO_MARK} If any checks failed, run the following commands:"
echo -e "1. Reinstall: ${YELLOW}./setup.sh${NC}"
echo -e "2. Configure GitHub MCP: ${YELLOW}./mcp-servers/github/github_mcp.sh setup${NC}"
echo -e "3. Reload shell configuration: ${YELLOW}source ~/.bashrc${NC} (or ~/.zshrc)"
echo ""
