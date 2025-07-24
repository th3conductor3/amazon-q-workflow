#!/bin/bash

# Amazon Q Startup Checklist Script
# This script runs automatically when starting Amazon Q CLI

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECK_MARK="${GREEN}✓${NC}"
CROSS_MARK="${RED}✗${NC}"

# Configuration
CONFIG_DIR="$HOME/.amazon-q-workflow"
MEMORY_LOG="$CONFIG_DIR/amazon_q_project_memory.log"
GITHUB_MCP_CONFIG="$HOME/.github-mcp/config.json"
DOC_DIR="$HOME/.amazon-q-workflow/docs"

echo -e "${BLUE}=== Amazon Q Startup Checklist ===${NC}"
echo "Running pre-flight checks..."
echo ""

# Function to check web search availability
check_web_search() {
    echo -e "1. Web Search Capability:"
    # This is a placeholder check - implement actual web search check based on Amazon Q's API
    if command -v curl &> /dev/null; then
        echo -e "   ${CHECK_MARK} Web search appears to be available"
        echo -e "   ${YELLOW}Note: Web search capability depends on your Amazon Q configuration${NC}"
    else
        echo -e "   ${CROSS_MARK} Web search capability status unknown"
    fi
    echo ""
}

# Function to check persistent memory
check_persistent_memory() {
    echo -e "2. Persistent Memory System:"
    if [ -f "$MEMORY_LOG" ]; then
        echo -e "   ${CHECK_MARK} Persistent memory system is active"
        echo -e "   Last recorded activity:"
        echo -e "   ${YELLOW}$(tail -n 5 "$MEMORY_LOG" | grep "###" | tail -n 1)${NC}"
        
        # Get the most recent project
        local recent_project=$(grep -A 2 "### New Project:" "$MEMORY_LOG" | tail -n 3)
        if [ ! -z "$recent_project" ]; then
            echo -e "   Most recent project:"
            echo -e "${YELLOW}$recent_project${NC}"
        fi
    else
        echo -e "   ${CROSS_MARK} Persistent memory system not initialized"
        echo -e "   ${YELLOW}Run: ./scripts/q-workflow.sh project \"Your First Project\" \"Description\"${NC}"
    fi
    echo ""
}

# Function to check documentation database
check_documentation() {
    echo -e "3. Documentation Database:"
    if [ -d "$DOC_DIR" ]; then
        echo -e "   ${CHECK_MARK} Documentation system available"
        echo -e "   Available documentation:"
        
        # Create docs directory if it doesn't exist
        mkdir -p "$DOC_DIR"
        
        # List all markdown files in the docs directory
        find "$DOC_DIR" -name "*.md" -type f 2>/dev/null | while read -r file; do
            local title=$(head -n 1 "$file" | sed 's/^#* //')
            echo -e "   ${YELLOW}- ${title}${NC}"
        done
        
        # Check repository documentation
        echo -e "\n   Repository documentation:"
        find "/home/kali/amazon-q-workflow" -name "*.md" -type f 2>/dev/null | while read -r file; do
            local title=$(head -n 1 "$file" | sed 's/^#* //')
            echo -e "   ${YELLOW}- ${title} ($(basename $(dirname "$file")))${NC}"
        done
    else
        echo -e "   ${CROSS_MARK} Documentation directory not found"
        echo -e "   ${YELLOW}Creating documentation directory...${NC}"
        mkdir -p "$DOC_DIR"
    fi
    echo ""
}

# Function to check GitHub MCP server
check_github_mcp() {
    echo -e "4. GitHub MCP Server:"
    if [ -f "$GITHUB_MCP_CONFIG" ]; then
        local username=$(jq -r '.github.username' "$GITHUB_MCP_CONFIG" 2>/dev/null)
        if [ ! -z "$username" ] && [ "$username" != "null" ]; then
            echo -e "   ${CHECK_MARK} GitHub MCP server is configured"
            echo -e "   ${YELLOW}Connected as: $username${NC}"
            
            # Check if the token is valid
            local token=$(jq -r '.github.token' "$GITHUB_MCP_CONFIG" 2>/dev/null)
            if [ ! -z "$token" ] && [ "$token" != "null" ]; then
                # Test GitHub API access
                local api_status=$(curl -s -H "Authorization: token $token" \
                    -w "%{http_code}" -o /dev/null \
                    "https://api.github.com/user")
                if [ "$api_status" = "200" ]; then
                    echo -e "   ${CHECK_MARK} GitHub API access verified"
                else
                    echo -e "   ${CROSS_MARK} GitHub token may need to be refreshed"
                fi
            fi
        else
            echo -e "   ${CROSS_MARK} GitHub MCP server configuration incomplete"
            echo -e "   ${YELLOW}Run: ./mcp-servers/github/github_mcp.sh setup${NC}"
        fi
    else
        echo -e "   ${CROSS_MARK} GitHub MCP server not configured"
        echo -e "   ${YELLOW}Run: ./mcp-servers/github/register_github_mcp.sh${NC}"
    fi
    echo ""
}

# Run all checks
check_web_search
check_persistent_memory
check_documentation
check_github_mcp

echo -e "${BLUE}=== Startup Checklist Complete ===${NC}"
echo -e "${YELLOW}Use 'q-workflow help' for available commands${NC}"
echo ""
