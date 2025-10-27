# Claude Code with Baseten Model APIs

Use Claude Code with Baseten's GLM-4.6, GPT-OSS 120B, and other frontier open-source models via LiteLLM proxy.

## Quick Start

### 1. Install Dependencies

```bash
# Install LiteLLM
pip install litellm[proxy]
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code
```

### 2. Set your Baseten API key

```bash
cp env.example .env
# Edit .env and add your BASETEN_API_KEY from https://app.baseten.co/settings/api_keys
```

### 3. Start the LiteLLM proxy

```bash
./setup_baseten_claude_code.sh
```

Keep this terminal running.

### 4. Launch Claude Code (in a new terminal)

```bash
./launch_claude_code.sh
```

That's it! Claude Code will now use Baseten models.

## Available Models

The following Baseten models are configured:

- **GLM-4.6**: `baseten/zai-org/glm-4.6`(default)
- **GPT-OSS 120B**: `baseten/openai/gpt-oss-120b`
- **Qwen3 235B**: `baseten/qwen/qwen3-235b-a22b-instruct-2507`
- **Qwen3 Coder 480B**: `baseten/qwen/qwen3-coder-480b-a35b-instruct`
- **Kimi K2**: `baseten/moonshotai/kimi-k2-instruct-0905`
- **DeepSeek V3.1**: `baseten/deepseek-ai/deepseek-v3.1`
- **DeepSeek R1**: `baseten/deepseek-ai/deepseek-r1-0528`
- **DeepSeek V3**: `baseten/deepseek-ai/deepseek-v3-0324`

### Switching Models

Switch models in Claude Code after the client has launched using:
```
/model baseten/deepseek-ai/deepseek-v3.1
```

Or launch with a specific model:
```bash
./launch_claude_code.sh --model baseten/moonshotai/kimi-k2-instruct-0905
```
Note:
Currently, Baseten does not support `thinking` in Claude code. Please ensure it is turned off.

## How It Works

```
Claude Code → LiteLLM Proxy (localhost:4000) → Baseten API
```

**Note**: Claude Code normalizes model names to lowercase. The proxy handles the routing from lowercase to proper Baseten model APIs case-sensitive slugs.
The proxy maps Claude Code's default models (`claude-haiku`, `claude-sonnet`, `claude-opus`) to Baseten GPT-OSS 120B to suppress Claude Code's internal checks that cause errors.

## Files

- `litellm_config.yaml` - LiteLLM proxy configuration with all models
- `setup_baseten_claude_code.sh` - Start the proxy
- `launch_claude_code.sh` - Launch Claude Code with proper environment
- `env.example` - Environment variables template
- `.env` - Your API keys (not committed to git)

## Troubleshooting

**Proxy not starting**: 
- Check port 4000 is available

**Claude Code errors**: 
- Ensure proxy is running (`curl http://localhost:4000/health`)
- Verify `.env` has valid `BASETEN_API_KEY`

**Model not found**: 
- The proxy automatically maps Claude models to Baseten
- Use `/model` command to switch to available Baseten models