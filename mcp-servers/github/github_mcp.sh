#!/bin/bash

# GitHub MCP Server for Amazon Q
# A simplified implementation for direct GitHub integration

# Configuration
CONFIG_DIR="$HOME/.github-mcp"
CONFIG_FILE="$CONFIG_DIR/config.json"
LOG_FILE="$CONFIG_DIR/mcp-server.log"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to set up configuration
setup_config() {
    echo -e "${BLUE}Setting up GitHub MCP configuration...${NC}"
    
    # Ask for GitHub username
    read -p "Enter your GitHub username: " GITHUB_USERNAME
    
    # Ask for GitHub personal access token
    read -sp "Enter your GitHub personal access token: " GITHUB_TOKEN
    echo ""
    
    # Create config file
    cat > "$CONFIG_FILE" << EOF
{
  "github": {
    "username": "$GITHUB_USERNAME",
    "token": "$GITHUB_TOKEN",
    "api_url": "https://api.github.com"
  }
}
EOF
    
    echo -e "${GREEN}Configuration saved to $CONFIG_FILE${NC}"
}

# Function to load configuration
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Configuration file not found. Running setup...${NC}"
        setup_config
    fi
    
    GITHUB_USERNAME=$(jq -r '.github.username' "$CONFIG_FILE")
    GITHUB_TOKEN=$(jq -r '.github.token' "$CONFIG_FILE")
    API_URL=$(jq -r '.github.api_url' "$CONFIG_FILE")
    
    if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
        echo -e "${RED}Invalid configuration. Running setup again...${NC}"
        setup_config
        load_config
    fi
}

# Function to create a GitHub repository
create_repo() {
    local repo_name="$1"
    local description="$2"
    local is_private="${3:-false}"
    
    echo -e "${BLUE}Creating GitHub repository: $repo_name${NC}"
    
    # Create the repository
    response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "$API_URL/user/repos" \
        -d "{\"name\":\"$repo_name\",\"description\":\"$description\",\"private\":$is_private}")
    
    # Check if successful
    if echo "$response" | jq -e '.html_url' > /dev/null; then
        repo_url=$(echo "$response" | jq -r '.html_url')
        echo -e "${GREEN}Repository created successfully: $repo_url${NC}"
        return 0
    else
        error=$(echo "$response" | jq -r '.message')
        echo -e "${RED}Failed to create repository: $error${NC}"
        return 1
    fi
}

# Function to push to a GitHub repository
push_to_repo() {
    local repo_path="$1"
    local repo_name="$2"
    
    echo -e "${BLUE}Pushing to GitHub repository: $repo_name${NC}"
    
    # Navigate to the repository directory
    cd "$repo_path" || { echo -e "${RED}Directory not found: $repo_path${NC}"; return 1; }
    
    # Check if git is initialized
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}Initializing git repository...${NC}"
        git init
        git branch -m main
    fi
    
    # Add all files
    echo -e "${YELLOW}Adding files to git...${NC}"
    git add .
    
    # Commit
    echo -e "${YELLOW}Committing changes...${NC}"
    git commit -m "Pushed via GitHub MCP server"
    
    # Add remote if it doesn't exist
    if ! git remote | grep -q "origin"; then
        echo -e "${YELLOW}Adding remote origin...${NC}"
        git remote add origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$repo_name.git"
    fi
    
    # Push to GitHub
    echo -e "${YELLOW}Pushing to GitHub...${NC}"
    if git push -u origin main; then
        echo -e "${GREEN}Repository pushed successfully: https://github.com/$GITHUB_USERNAME/$repo_name${NC}"
        return 0
    else
        echo -e "${RED}Failed to push repository${NC}"
        return 1
    fi
}

# Function to display help
display_help() {
    echo -e "${BLUE}GitHub MCP Server - Usage Guide${NC}"
    echo ""
    echo -e "${GREEN}Commands:${NC}"
    echo -e "  ${YELLOW}setup${NC}                                          # Set up GitHub credentials"
    echo -e "  ${YELLOW}create-repo <name> <description> [private]${NC}     # Create a GitHub repository"
    echo -e "  ${YELLOW}push-repo <local_path> <repo_name>${NC}            # Push local repository to GitHub"
    echo -e "  ${YELLOW}help${NC}                                          # Display this help message"
}

# Main function
main() {
    case "$1" in
        setup)
            setup_config
            ;;
        create-repo)
            if [ -z "$2" ] || [ -z "$3" ]; then
                echo -e "${RED}Missing arguments. Usage: $0 create-repo <name> <description> [private]${NC}"
                return 1
            fi
            load_config
            create_repo "$2" "$3" "${4:-false}"
            ;;
        push-repo)
            if [ -z "$2" ] || [ -z "$3" ]; then
                echo -e "${RED}Missing arguments. Usage: $0 push-repo <local_path> <repo_name>${NC}"
                return 1
            fi
            load_config
            push_to_repo "$2" "$3"
            ;;
        help|--help|-h)
            display_help
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            display_help
            return 1
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
