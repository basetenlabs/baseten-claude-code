#!/bin/bash

# Set up Claude Code to use Baseten models via LiteLLM proxy
# This script modifies your shell config (.zshrc or .bashrc) to export the necessary environment variables
#
# IMPORTANT: This script MUST be sourced, not executed!
# Usage: source ./set-baseten.sh
#    Or: . ./set-baseten.sh

# Check if script was sourced (not executed)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ ERROR: This script must be sourced, not executed!"
    echo ""
    echo "   Please run:"
    echo "   source $(cd "$(dirname "$0")" && pwd)/set-baseten.sh"
    echo "   # Or: . $(cd "$(dirname "$0")" && pwd)/set-baseten.sh"
    echo ""
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect shell config file
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
    SHELL_NAME="zsh"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_NAME="bash"
else
    # Default to .zshrc on macOS, .bashrc on Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
        SHELL_NAME="zsh"
    else
        SHELL_CONFIG="$HOME/.bashrc"
        SHELL_NAME="bash"
    fi
fi

echo "🔧 Configuring Claude Code to use Baseten models"
echo "📝 Shell config: $SHELL_CONFIG"
echo ""

# Check if .env exists
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo "❌ .env file not found in $SCRIPT_DIR!"
    echo "Please create it from env.example and add your BASETEN_API_KEY"
    exit 1
fi

# Source .env to get the values
source "$SCRIPT_DIR/.env"

# Remove any existing Baseten/Anthropic Claude Code configuration
# This removes lines between "# Baseten Claude Code Configuration" and "# End Baseten Claude Code Configuration"
if grep -q "# Baseten Claude Code Configuration" "$SHELL_CONFIG" 2>/dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' '/# Baseten Claude Code Configuration/,/# End Baseten Claude Code Configuration/d' "$SHELL_CONFIG"
    else
        # Linux sed
        sed -i '/# Baseten Claude Code Configuration/,/# End Baseten Claude Code Configuration/d' "$SHELL_CONFIG"
    fi
    echo "✅ Removed existing Baseten Claude Code configuration"
fi

# Add Baseten configuration
cat >> "$SHELL_CONFIG" << EOF

# Baseten Claude Code Configuration
# Configured by set-baseten.sh from $SCRIPT_DIR
export ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL"
export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
# End Baseten Claude Code Configuration
EOF

echo "✅ Added Baseten configuration to $SHELL_CONFIG"
echo ""

# Export variables in current shell (script is sourced, so this works)
export ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL"
export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
echo "🔄 Environment variables set in current shell"

echo ""
echo "📋 Next steps:"
echo "1. Start LiteLLM proxy:"
echo "   cd $SCRIPT_DIR && ./setup_baseten_claude_code.sh"
echo ""
echo "2. Run 'claude' from any directory - it will use Baseten models!"
echo ""
echo "💡 To switch back to Anthropic, run: source $SCRIPT_DIR/set-anthropic.sh"

