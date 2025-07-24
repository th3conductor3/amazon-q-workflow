# Contributing to Amazon Q Enhanced Workflow

Thank you for your interest in contributing to the Amazon Q Enhanced Workflow project! This document provides guidelines and instructions for contributing.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [How to Contribute](#how-to-contribute)
4. [Development Workflow](#development-workflow)
5. [Style Guidelines](#style-guidelines)
6. [Submitting Changes](#submitting-changes)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- Bash (version 4.0 or higher recommended)
- Git
- Amazon Q CLI installed

### Setting Up Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/amazon-q-workflow.git
   cd amazon-q-workflow
   ```
3. Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/originalusername/amazon-q-workflow.git
   ```

## How to Contribute

### Reporting Bugs

- Check if the bug has already been reported in the Issues section
- Use the bug report template when creating a new issue
- Include detailed steps to reproduce the bug
- Specify your environment (OS, bash version, etc.)

### Suggesting Enhancements

- Check if the enhancement has already been suggested in the Issues section
- Use the feature request template when creating a new issue
- Clearly describe the problem and solution
- Consider how the enhancement would benefit other users

### Code Contributions

1. Find an issue to work on or create a new one
2. Comment on the issue to let others know you're working on it
3. Create a new branch for your changes
4. Make your changes following the style guidelines
5. Test your changes thoroughly
6. Submit a pull request

## Development Workflow

### Branching Strategy

- `main`: Stable release branch
- `develop`: Development branch for next release
- Feature branches: `feature/your-feature-name`
- Bug fix branches: `fix/bug-description`

### Testing

Before submitting changes, test your code:

1. Run the setup script to ensure it works correctly
2. Test all commands and features you've modified
3. Verify compatibility with different environments if possible

## Style Guidelines

### Bash Scripting

- Use 2-space indentation
- Add comments for complex logic
- Use meaningful variable and function names
- Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html) where applicable

### Documentation

- Keep documentation up-to-date with code changes
- Use clear, concise language
- Include examples for new features

## Submitting Changes

### Pull Request Process

1. Update the README.md and documentation with details of changes
2. Increase version numbers in scripts and documentation
3. Submit the pull request to the `develop` branch
4. Address any feedback from code reviews
5. Once approved, your changes will be merged

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for adding or modifying tests
- `chore:` for maintenance tasks

Example: `feat: add project archiving functionality`

## Thank You!

Your contributions help make this project better for everyone. We appreciate your time and effort!
