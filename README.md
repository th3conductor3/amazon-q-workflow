# Amazon Q Enhanced Workflow

A repository to standardize and enhance your Amazon Q CLI experience with persistent memory and multi-AI collaboration.

## Overview

This repository provides tools to solve common limitations with AI assistants:

1. **Persistent Memory**: Keep track of projects and conversations across sessions
2. **Multi-AI Collaboration**: Leverage multiple AI assistants (Amazon Q + Gemini) together
3. **Standardized Workflow**: Consistent experience for any Amazon Q user
4. **GitHub Integration**: Direct GitHub integration through MCP server

## Quick Start

### Standard Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/th3conductor3/amazon-q-workflow.git
   cd amazon-q-workflow
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

### Global Installation (Recommended)

For a system-wide installation that works for all users and terminals:

1. Clone and enter the repository:
   ```bash
   git clone https://github.com/th3conductor3/amazon-q-workflow.git
   cd amazon-q-workflow
   ```

2. Run the global installer:
   ```bash
   sudo ./scripts/global-installer.sh
   ```

3. Restart your terminal or reload your shell configuration:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

### Setting Up GitHub Integration

After installation, set up GitHub integration:
```bash
./mcp-servers/github/register_github_mcp.sh
./mcp-servers/github/github_mcp.sh setup
```

### Start Using Enhanced Workflow

The enhanced workflow provides a startup checklist showing:
1. GitHub integration status
2. Recent activity log
3. Available documentation

```bash
# Start Amazon Q with enhanced features
q

# Log a new project
q-workflow project "Project Name" "Description"

# View your project history
q-workflow memory

# Get help with commands
q-workflow help
```

## Features

### Persistent Memory System

- **Project Tracking**: Log and update projects across sessions
- **Conversation Memory**: Record important conversation notes
- **Session Continuity**: Remind Amazon Q of previous work

### Multi-AI Collaboration

- **Shared Memory**: Pass information between different AI assistants
- **Task Division**: Leverage the strengths of different AI models
- **Context Management**: Optimize token usage across assistants

### GitHub Integration via MCP

- Create GitHub repositories directly from Amazon Q
- Push local repositories to GitHub
- Manage GitHub operations through simple commands

## Directory Structure

- `scripts/`: Core functionality scripts
- `templates/`: Template files for various purposes
- `docs/`: Detailed documentation
- `mcp-servers/`: MCP server implementations
  - `github/`: GitHub MCP server

## Usage Guide

See the [detailed usage guide](docs/USAGE.md) for complete instructions.

## GitHub Integration

The GitHub MCP server provides these commands:

1. Create a new repository:
   ```bash
   github___create-repo <name> <description> [private]
   ```

2. Push a local repository:
   ```bash
   github___push-repo <local_path> <repo_name>
   ```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
