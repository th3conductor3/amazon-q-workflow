#!/bin/bash

# Register GitHub MCP Server with Amazon Q
# This script creates the necessary configuration for Amazon Q to recognize our GitHub MCP server

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Register GitHub MCP Server with Amazon Q ===${NC}"
echo ""

# Configuration
MCP_CONFIG_DIR="$HOME/.amazon-q/mcp-servers"
GITHUB_MCP_DIR="$MCP_CONFIG_DIR/github-mcp"
GITHUB_MCP_SCRIPT="/home/kali/github_mcp.sh"

# Create MCP configuration directory
mkdir -p "$GITHUB_MCP_DIR"

# Create MCP server configuration file
cat > "$GITHUB_MCP_DIR/config.json" << EOF
{
  "name": "github",
  "version": "1.0.0",
  "description": "GitHub MCP server for Amazon Q",
  "tools": [
    {
      "name": "github___create-repo",
      "description": "Create a new GitHub repository",
      "parameters": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "Name of the repository"
          },
          "description": {
            "type": "string",
            "description": "Description of the repository"
          },
          "private": {
            "type": "boolean",
            "description": "Whether the repository should be private",
            "default": false
          }
        },
        "required": ["name", "description"]
      }
    },
    {
      "name": "github___push-repo",
      "description": "Push a local repository to GitHub",
      "parameters": {
        "type": "object",
        "properties": {
          "local_path": {
            "type": "string",
            "description": "Local path to the repository"
          },
          "repo_name": {
            "type": "string",
            "description": "Name of the GitHub repository"
          }
        },
        "required": ["local_path", "repo_name"]
      }
    }
  ]
}
EOF

# Create MCP server wrapper script
cat > "$GITHUB_MCP_DIR/server.sh" << EOF
#!/bin/bash

# GitHub MCP Server Wrapper for Amazon Q

# Get the tool name from the first argument
TOOL_NAME="\$1"
shift

case "\$TOOL_NAME" in
  github___create-repo)
    /home/kali/github_mcp.sh create-repo "\$@"
    ;;
  github___push-repo)
    /home/kali/github_mcp.sh push-repo "\$@"
    ;;
  *)
    echo "Unknown tool: \$TOOL_NAME"
    exit 1
    ;;
esac
EOF

# Make the wrapper script executable
chmod +x "$GITHUB_MCP_DIR/server.sh"

echo -e "${GREEN}GitHub MCP server registered successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Set up your GitHub credentials: ${GREEN}/home/kali/github_mcp.sh setup${NC}"
echo -e "2. Restart Amazon Q CLI to recognize the new MCP server"
echo -e "3. You can now use the following tools in Amazon Q:"
echo -e "   - ${GREEN}github___create-repo${NC} - Create a new GitHub repository"
echo -e "   - ${GREEN}github___push-repo${NC} - Push a local repository to GitHub"
echo ""
echo -e "${YELLOW}Note: This is a custom implementation and may require adjustments based on Amazon Q's actual MCP implementation.${NC}"
