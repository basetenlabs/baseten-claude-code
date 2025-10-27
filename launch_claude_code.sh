#!/bin/bash

# Launch Claude Code with Baseten proxy configuration

cd "$(dirname "$0")"

# Load environment variables from .env
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "Please create it from env.example"
    exit 1
fi

source .env

# Verify required environment variables are set
if [ -z "$ANTHROPIC_BASE_URL" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ Missing required environment variables in .env"
    echo "Please set ANTHROPIC_BASE_URL and ANTHROPIC_API_KEY"
    exit 1
fi

# Explicitly export variables for Claude Code. Required, or else /login popups will appear
export ANTHROPIC_BASE_URL
export ANTHROPIC_API_KEY

# Check if proxy is running
if ! curl -s http://localhost:4000/health > /dev/null 2>&1; then
    echo "❌ LiteLLM proxy is not running!"
    echo "Please start it first with: bash setup_baseten_claude_code.sh"
    exit 1
fi

echo "✅ Proxy is running"
echo "🚀 Launching Claude Code..."
echo ""

# Launch Claude Code with Baseten model (unless user specifies a different model)
if [[ "$*" == *"--model"* ]]; then
    claude "$@"
else
    echo "🚀 Launching Claude Code with default model: Baseten GLM-4.6..."
    claude --model baseten/zai-org/glm-4.6 "$@"
fi

