# Amazon Q Enhanced Workflow

A repository to standardize and enhance your Amazon Q CLI experience with persistent memory and multi-AI collaboration.

## Overview

This repository provides tools to solve common limitations with AI assistants:

1. **Persistent Memory**: Keep track of projects and conversations across sessions
2. **Multi-AI Collaboration**: Leverage multiple AI assistants (Amazon Q + Gemini) together
3. **Standardized Workflow**: Consistent experience for any Amazon Q user

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/amazon-q-workflow.git
   cd amazon-q-workflow
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. Start using the enhanced workflow:
   ```bash
   # Log a new project
   ./scripts/q-workflow.sh project "Project Name" "Description"
   
   # Use Amazon Q with memory context
   q
   
   # Use Gemini (if available)
   gemini
   
   # View your project history
   ./scripts/q-workflow.sh memory
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

## Directory Structure

- `scripts/`: Core functionality scripts
- `templates/`: Template files for various purposes
- `docs/`: Detailed documentation

## Usage Guide

See the [detailed usage guide](docs/USAGE.md) for complete instructions.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
