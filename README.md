# Claude Code with Baseten Model APIs

Run Claude Code with Baseten's GLM-4.6, GPT-OSS 120B, Kimi K2 and other frontier open-source models via LiteLLM proxy. We have designed shell scripts to help you use [Baseten Model APIs](https://www.baseten.co/products/model-apis/) in Claude Code <1min.

This is an alternative way of powering Claude Code with higher throughput (tokens per second) and at a substantially lower cost, with on par coding performance.

## Performance & Pricing (Updated Oct 27th, 2025)

### Benchmarks (GLM 4.6 vs. Claude Sonnet 4.5)
In evaluations across 8 authoritative benchmarks for general model capabilities—including AIME 25, GPQA, LCB v6, HLE, and SWE-Bench Verified—GLM-4.6 achieves performance on par with Claude Sonnet 4/Claude Sonnet 4.6 on several leaderboards.
![alt text](/glm-4.6-benchmarks.png)

### Pricing (Lower is better) 
| Model | Input Tokens | Output Tokens |
|-------|--------------|---------------|
| Claude Sonnet 4.5 | $3.00 /M | $15.00 /M |
| GLM-4.6 on Baseten | $0.60 /M | $2.20 /M |

### Speed (Throughput) (Higher is better)
| Model | Tokens per Second |
|-------|-------------------|
| Claude Sonnet 4.5 | ~60 TPS |
| GLM-4.6 on Baseten | ~100+ TPS |

## Quick Start

### 1. Install Dependencies and Clone repo

```bash
# Install LiteLLM
pip install litellm[proxy]
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code
# Clone and enter repo directory
git clone https://github.com/basetenlabs/baseten-claude-code.git
cd /baseten-claude-code
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

You can launch Claude Code from anywhere:

```bash
# From the baseten-claude-code directory
./launch_claude_code.sh

# Or from any other directory (Claude Code will open in that directory)
cd /path/to/your/project
/path/to/baseten-claude-code/launch_claude_code.sh

# Or add to your PATH for easy access
# Add to ~/.zshrc or ~/.bashrc:
export PATH="$PATH:/path/to/baseten-claude-code"
# Then you can run from anywhere:
launch_claude_code.sh
```

**Note**: The script will find its configuration files automatically, so you can run it from any directory. Claude Code will open in your current working directory.

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