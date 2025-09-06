#!/bin/bash

# Post-create script for AI Gateway Dev Container
# This script runs after the container is created to set up additional configurations

echo "Running post-create setup..."

# Ensure the script continues even if some commands fail
set +e

# Install global npm packages for AI coding assistants if needed
if command -v npm &> /dev/null; then
    echo "Installing global npm packages for AI assistants..."
    
    # Install Claude Code CLI
    echo "🤖 Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
    
    # Install OpenAI Codex CLI
    echo "🤖 Installing OpenAI Codex CLI..."
    npm install -g @openai/codex
    
    # Install TypeScript globally for better language support
    echo "📝 Installing TypeScript..."
    npm install -g typescript@latest
    
    # Install Prettier for code formatting
    echo "✨ Installing Prettier..."
    npm install -g prettier
    
    echo "Global npm packages installed."
else
    echo "npm not found, skipping global package installation."
fi

# Configure Git (if not already configured)
if [ -z "$(git config --global user.email)" ]; then
    echo "Note: Git user email not configured. You may want to run:"
    echo "  git config --global user.email 'your.email@example.com'"
fi

if [ -z "$(git config --global user.name)" ]; then
    echo "Note: Git user name not configured. You may want to run:"
    echo "  git config --global user.name 'Your Name'"
fi

# Set up GitHub CLI authentication reminder
if ! gh auth status &> /dev/null; then
    echo ""
    echo "GitHub CLI is not authenticated. To authenticate, run:"
    echo "  gh auth login"
    echo ""
fi

# Set up Azure CLI authentication reminder
if ! az account show &> /dev/null; then
    echo ""
    echo "Azure CLI is not authenticated. To authenticate, run:"
    echo "  az login"
    echo ""
fi

# Create a workspace settings file if it doesn't exist
WORKSPACE_SETTINGS=".vscode/settings.json"
if [ ! -f "$WORKSPACE_SETTINGS" ]; then
    echo "Creating workspace settings..."
    mkdir -p .vscode
    cat > "$WORKSPACE_SETTINGS" << 'EOF'
{
    "python.defaultInterpreterPath": "/usr/local/bin/python",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black",
    "python.testing.pytestEnabled": true,
    "editor.formatOnSave": true,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "jupyter.askForKernelRestart": false
}
EOF
    echo "Workspace settings created."
fi

# Install Python development tools
echo "Installing Python development tools..."
pip install --upgrade black pylint pytest ipykernel

# Register Python kernel for Jupyter
python -m ipykernel install --user --name python3 --display-name "Python 3"

echo ""
echo "✅ Post-create setup completed!"
echo ""
echo "🔑 Authentication reminders:"
echo "  - Run 'gh auth login' to authenticate with GitHub"
echo "  - Run 'az login' to authenticate with Azure"
echo "  - Run 'claude' to start Claude Code CLI (requires authentication on first use)"
echo "  - Run 'codex' to start OpenAI Codex CLI (requires ChatGPT Plus/API key)"
echo ""
echo "🚀 Happy coding with your AI assistants!"