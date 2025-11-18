#!/bin/bash

# Set up Claude Code to use Anthropic models directly
# This script removes Baseten configuration from your shell config
#
# IMPORTANT: This script MUST be sourced, not executed!
# Usage: source ./set-anthropic.sh
#    Or: . ./set-anthropic.sh

# Check if script was sourced (not executed)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ ERROR: This script must be sourced, not executed!"
    echo ""
    echo "   Please run:"
    echo "   source $(cd "$(dirname "$0")" && pwd)/set-anthropic.sh"
    echo "   # Or: . $(cd "$(dirname "$0")" && pwd)/set-anthropic.sh"
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

echo "🔧 Configuring Claude Code to use Anthropic models directly"
echo "📝 Shell config: $SHELL_CONFIG"
echo ""

# Remove Baseten configuration if it exists
if grep -q "# Baseten Claude Code Configuration" "$SHELL_CONFIG" 2>/dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' '/# Baseten Claude Code Configuration/,/# End Baseten Claude Code Configuration/d' "$SHELL_CONFIG"
    else
        # Linux sed
        sed -i '/# Baseten Claude Code Configuration/,/# End Baseten Claude Code Configuration/d' "$SHELL_CONFIG"
    fi
    echo "✅ Removed Baseten configuration from $SHELL_CONFIG"
    echo ""
    
    # Clear environment variables in current shell (script is sourced, so this works)
    echo "🔄 Clearing Baseten environment variables from current shell..."
    unset ANTHROPIC_BASE_URL ANTHROPIC_API_KEY 2>/dev/null || true
    
    echo ""
    echo "📋 Next steps:"
    echo "1. Make sure you have ANTHROPIC_API_KEY set in your environment"
    echo "   (Claude Code will use Anthropic's default API endpoint)"
    echo ""
    echo "2. Now 'claude' will use Anthropic models directly"
else
    echo "ℹ️  No Baseten configuration found in $SHELL_CONFIG"
    echo "   Claude Code should already be using Anthropic models"
    echo ""
    echo "💡 To switch to Baseten, run: source $SCRIPT_DIR/set-baseten.sh"
fi


