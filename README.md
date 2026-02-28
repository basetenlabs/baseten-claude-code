# Claude Code with Baseten Model APIs

Run Claude Code with Baseten's MiniMax M2.5, GLM 5, Kimi K2.5 and other frontier open-source models via LiteLLM proxy. This enables Claude Code to work seamlessly with IDE integrations (PyCharm, VS Code, etc.) and provides higher throughput at lower cost.

This is an alternative way of powering Claude Code with higher throughput (tokens per second) and at a substantially lower cost, with on par coding performance.

## Sample Performance & Pricing

### Benchmarks (Kimi K2.5 vs. Claude Opus 4.6) 
![alt text](/kimi-k2.5-benchmarks.png)

### Pricing (Lower is better) 
| Model | Input Tokens | Output Tokens |
|-------|--------------|---------------|
| Claude Opus 4.6 | $5.00 /M | $25.00 /M |
| Kimi K2.5 on Baseten | $0.60 /M | $3.00 /M |

### Speed (Throughput) (Higher is better)
| Model | Tokens per Second |
|-------|-------------------|
| Claude Opus 4.6 | ~60+ TPS |
| Kimi K2.5 on Baseten | ~300+ TPS |

## Prerequisites

Before setting up, you'll need:

1. **LiteLLM** - Install with `pip install litellm[proxy]`
2. **Claude Code CLI** - Install with `npm install -g @anthropic-ai/claude-code`
3. **Baseten API Key** - Get yours from [Baseten API Keys](https://app.baseten.co/settings/api_keys)

## Quick Start

### 1. Clone and Configure Env.

```bash
git clone https://github.com/basetenlabs/baseten-claude-code.git
cd baseten-claude-code
cp env.example .env
# Edit .env and add your BASETEN_API_KEY
```

### 2. Set Up Integration

For IDE integrations and seamless `claude` command usage:

```bash
source ./set-baseten.sh
```

**Important**: You must **source** the script (don't execute it). If you try to run `./set-baseten.sh` directly, it will exit with an error. Sourcing sets environment variables immediately in your current shell and configures your shell so that `claude` works globally and integrates with IDEs like PyCharm, VS Code, and Cursor.

### 3. Start LiteLLM Proxy

Run the proxy:

```bash
./setup_baseten_claude_code.sh
```

Keep this terminal running.

### 4. Use Claude Code

Now you can run `claude` from any directory:

```bash
cd /path/to/your/project
claude
```

Claude Code will use Baseten models automatically! 

**To switch back to Anthropic:**
```bash
source ./set-anthropic.sh
```

## Configuration

### Environment Variables

The `.env` file contains:

- `BASETEN_API_KEY`: Your Baseten API key (used by LiteLLM proxy)
- `ANTHROPIC_BASE_URL`: Set to `http://localhost:4000` (LiteLLM proxy endpoint)
- `ANTHROPIC_API_KEY`: Dummy key to pass Claude Code's validation

When you source `set-baseten.sh`, these are exported in your shell config (`.zshrc`/`.bashrc`) so `claude` works globally.

## Available Models

The following Baseten models are pre-configured:

- **DeepSeek V3**: `baseten/deepseek-ai/deepseek-v3-0324`
- **DeepSeek V3.1**: `baseten/deepseek-ai/deepseek-v3.1`
- **GLM-4.6**: `baseten/zai-org/glm-4.6`
- **GLM-4.7**: `baseten/zai-org/glm-4.7`
- **GLM-5**: `baseten/zai-org/glm-5`
- **Kimi K2**: `baseten/moonshotai/kimi-k2-instruct-0905`
- **Kimi K2 Thinking**: `baseten/moonshotai/kimi-k2-thinking`
- **Kimi K2.5**: `baseten/moonshotai/kimi-k2.5`
- **MiniMax M2.5**: `baseten/minimaxai/minimax-m2.5`
- **GPT-OSS 120B**: `baseten/openai/gpt-oss-120b`

### Switching Models

Switch models in Claude Code after launch:

```
/model baseten/moonshotai/kimi-k2.5
```

Or launch with a specific model:

```bash
claude --model baseten/moonshotai/kimi-k2-thinking
```

## How It Works

```
Claude Code → LiteLLM Proxy (localhost:4000) → Baseten API
```

**Key points:**
- Claude Code normalizes model names to lowercase. The proxy handles routing from lowercase to proper Baseten model API case-sensitive slugs.
- The proxy maps Claude Code's default models (`claude-haiku`, `claude-sonnet`, `claude-opus`) to Baseten GPT-OSS 120B to suppress Claude Code's internal checks.
- `drop_params: true` ensures unsupported parameters are dropped, preventing errors.

## Files

- `litellm_config.yaml` - LiteLLM proxy configuration with all models
- `set-baseten.sh` - Configure shell to use Baseten models. **Must be sourced**: `source ./set-baseten.sh`
- `set-anthropic.sh` - Switch back to Anthropic models. **Must be sourced**: `source ./set-anthropic.sh`
- `setup_baseten_claude_code.sh` - Start the proxy
- `env.example` - Environment variables template
- `.env` - Your API keys (not committed to git)

## Troubleshooting

**Proxy not starting**: 
- Check port 4000 is available: `lsof -i :4000`
- Verify `.env` has valid `BASETEN_API_KEY`

**Claude Code errors**: 
- Ensure proxy is running: `curl http://localhost:4000/health`
- Verify environment variables are set: `echo $ANTHROPIC_BASE_URL`, `echo $ANTHROPIC_API_KEY`
- If you executed the script instead of sourcing it, source it now: `source ./set-baseten.sh`

**Model not found**: 
- The proxy automatically maps Claude models to Baseten
- Use `/model` command to switch to available Baseten models
- Check `litellm_config.yaml` has the model configured

## References

- [LiteLLM Documentation](https://docs.litellm.ai/)
- [LiteLLM Proxy Server](https://docs.litellm.ai/docs/proxy_server)
- [Baseten Model APIs](https://docs.baseten.co/development/model-apis/overview)