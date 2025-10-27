#!/bin/bash

# Start LiteLLM proxy for Claude Code with Baseten models

cd "$(dirname "$0")"

echo "🚀 Starting LiteLLM proxy..."

# Check for .env file
if [ ! -f .env ]; then
    echo "⚠️  .env file not found!"
    echo "Please create it from env.example and add your BASETEN_API_KEY"
    exit 1
fi

# Load environment variables
source .env

# Verify BASETEN_API_KEY is set
if [ -z "$BASETEN_API_KEY" ]; then
    echo "❌ BASETEN_API_KEY not set in .env file"
    exit 1
fi

# Start LiteLLM proxy
echo "✅ Starting LiteLLM proxy on http://localhost:4000"
echo "🎯 Use Ctrl+C to stop"
echo ""

litellm --config litellm_config.yaml

