#!/bin/bash

# Global installer for Amazon Q Enhanced Workflow
# This script installs the enhanced workflow system-wide

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Amazon Q Enhanced Workflow Global Installer ===${NC}"
echo ""

# Check for root/sudo access
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        if ! sudo -n true 2>/dev/null; then
            echo -e "${YELLOW}This script needs sudo privileges to install globally.${NC}"
            echo -e "${YELLOW}Please run with sudo or enter your password when prompted.${NC}"
            if ! sudo true; then
                echo -e "${RED}Failed to obtain sudo privileges. Exiting.${NC}"
                exit 1
            fi
        fi
    fi
}

# Install system-wide
install_global() {
    echo -e "${BLUE}Installing Amazon Q Enhanced Workflow globally...${NC}"
    
    # Create system directories
    sudo mkdir -p /etc/amazon-q-workflow
    sudo mkdir -p /usr/local/lib/amazon-q-workflow
    sudo mkdir -p /usr/local/share/amazon-q-workflow
    
    # Copy scripts and configurations
    sudo cp -r ../scripts/* /usr/local/lib/amazon-q-workflow/
    sudo cp -r ../docs/* /usr/local/share/amazon-q-workflow/
    
    # Create global configuration
    sudo tee /etc/amazon-q-workflow/config.json > /dev/null << EOF
{
    "workflow": {
        "version": "1.0.0",
        "scripts_dir": "/usr/local/lib/amazon-q-workflow",
        "docs_dir": "/usr/local/share/amazon-q-workflow",
        "user_config_dir": "~/.amazon-q-workflow"
    }
}
EOF
    
    # Create global q wrapper
    sudo tee /usr/local/bin/q > /dev/null << 'EOF'
#!/bin/bash

# Global Amazon Q Enhanced Wrapper
GLOBAL_CONFIG="/etc/amazon-q-workflow/config.json"
USER_CONFIG_DIR="$HOME/.amazon-q-workflow"
ORIGINAL_Q="$HOME/.local/bin/q-original"

# Ensure user config directory exists
mkdir -p "$USER_CONFIG_DIR"

# Run startup checks
if [ -f "/usr/local/lib/amazon-q-workflow/q-startup-check.sh" ]; then
    "/usr/local/lib/amazon-q-workflow/q-startup-check.sh"
fi

# Execute original Amazon Q
exec "$ORIGINAL_Q" "$@"
EOF
    
    # Make scripts executable
    sudo chmod +x /usr/local/bin/q
    sudo chmod +x /usr/local/lib/amazon-q-workflow/*.sh
    
    # Backup original q if not already done
    if [ ! -f "$HOME/.local/bin/q-original" ] && [ -f "$HOME/.local/bin/q" ]; then
        mv "$HOME/.local/bin/q" "$HOME/.local/bin/q-original"
    fi
    
    # Create symbolic links
    ln -sf /usr/local/lib/amazon-q-workflow/q-workflow.sh /usr/local/bin/q-workflow
    ln -sf /usr/local/lib/amazon-q-workflow/installation-check.sh /usr/local/bin/q-check-install
    
    echo -e "${GREEN}Global installation complete!${NC}"
}

# Update shell configuration
update_shell_config() {
    local shell_rc="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && shell_rc="$HOME/.zshrc"
    
    # Add PATH and aliases if not already present
    if ! grep -q "# Amazon Q Enhanced Workflow" "$shell_rc"; then
        echo "" >> "$shell_rc"
        echo "# Amazon Q Enhanced Workflow" >> "$shell_rc"
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$shell_rc"
        echo 'export AMAZON_Q_WORKFLOW_HOME="/usr/local/lib/amazon-q-workflow"' >> "$shell_rc"
        echo "alias q-help='q-workflow help'" >> "$shell_rc"
        echo -e "${GREEN}Shell configuration updated${NC}"
    fi
}

# Main installation process
main() {
    check_sudo
    install_global
    update_shell_config
    
    echo ""
    echo -e "${GREEN}Installation completed successfully!${NC}"
    echo -e "${YELLOW}Please restart your terminal or run: source ~/.bashrc${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "1. Start Amazon Q:           q"
    echo "2. Workflow commands:        q-workflow help"
    echo "3. Check installation:       q-check-install"
}

# Run main installation
main
