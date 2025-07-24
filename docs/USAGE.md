# Amazon Q Enhanced Workflow - Usage Guide

This document provides detailed instructions on how to use the Amazon Q Enhanced Workflow system.

## Table of Contents

1. [Installation](#installation)
2. [Basic Commands](#basic-commands)
3. [Project Management](#project-management)
4. [Multi-AI Collaboration](#multi-ai-collaboration)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

## Installation

### Standard Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/amazon-q-workflow.git
   cd amazon-q-workflow
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. The setup script will:
   - Create configuration directories in `~/.amazon-q-workflow/`
   - Install scripts and make them executable
   - Initialize the memory log and shared memory files
   - Create a symbolic link in `/usr/local/bin` (if possible)

### Manual Installation

If you prefer to install manually:

1. Create the configuration directory:
   ```bash
   mkdir -p ~/.amazon-q-workflow/scripts
   ```

2. Copy the scripts:
   ```bash
   cp ./scripts/q-workflow.sh ~/.amazon-q-workflow/scripts/
   chmod +x ~/.amazon-q-workflow/scripts/q-workflow.sh
   ```

3. Create a symbolic link (optional):
   ```bash
   sudo ln -s ~/.amazon-q-workflow/scripts/q-workflow.sh /usr/local/bin/q-workflow
   ```

## Basic Commands

### Getting Help

```bash
q-workflow help
```

### Managing Shared Memory

Save content to shared memory:
```bash
q-workflow save "Your content here"
```

Read from shared memory:
```bash
q-workflow read
```

### Starting Amazon Q with Memory Context

```bash
q-workflow start-q
```

### Viewing Version Information

```bash
q-workflow version
```

## Project Management

### Logging a New Project

```bash
q-workflow project "Project Name" "Detailed project description"
```

### Updating Project Status

```bash
q-workflow update "Project Name" "Current status update"
```

### Adding Conversation Notes

```bash
q-workflow note "Important information from this conversation"
```

### Viewing Project Memory

```bash
q-workflow memory
```

## Multi-AI Collaboration

### Workflow Between Amazon Q and Other AI Assistants

1. **Research Phase with Other AI**:
   - Use another AI assistant (like Gemini) for research or complex reasoning
   - Save the results to shared memory:
     ```bash
     q-workflow save "Research results from Gemini: ..."
     ```

2. **Implementation Phase with Amazon Q**:
   - Start Amazon Q with memory context:
     ```bash
     q-workflow start-q
     ```
   - Reference the shared memory in your conversation with Amazon Q

### Task Division Strategy

1. **Use Amazon Q for**:
   - AWS services and infrastructure
   - System operations and bash commands
   - File management and editing
   - AWS CLI operations

2. **Use other AI assistants for**:
   - Research tasks requiring large context windows
   - Creative content generation
   - Complex reasoning tasks
   - Storing large amounts of information

## Best Practices

### Maintaining Project Continuity

1. **Start Each Session with Context**:
   - Begin by viewing your project memory:
     ```bash
     q-workflow memory
     ```
   - Share relevant parts with Amazon Q at the start of your conversation

2. **Log Important Information**:
   - Log new projects as you start them
   - Update project status regularly
   - Record important conversation notes

3. **Use Descriptive Project Names**:
   - Choose clear, unique project names
   - This makes it easier to update and reference them later

### Optimizing Multi-AI Collaboration

1. **Clear Task Division**:
   - Be explicit about which tasks go to which AI assistant
   - Use the shared memory to pass information between them

2. **Context Management**:
   - Use other AI assistants to store large context
   - Summarize key points for Amazon Q

## Troubleshooting

### Common Issues

1. **Command Not Found**:
   - Ensure the script is in your PATH or use the full path:
     ```bash
     ~/.amazon-q-workflow/scripts/q-workflow.sh
     ```

2. **Permission Denied**:
   - Make sure the script is executable:
     ```bash
     chmod +x ~/.amazon-q-workflow/scripts/q-workflow.sh
     ```

3. **Memory Log Not Updating**:
   - Check file permissions:
     ```bash
     ls -la ~/.amazon-q-workflow/
     ```
   - Ensure you have write permissions to the directory

### Getting Help

If you encounter issues:

1. Check the GitHub repository for updates and issues
2. Submit a bug report with detailed information about your problem
