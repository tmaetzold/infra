-- Detect if ANTHROPIC_API_KEY is set
local has_anthropic_key = os.getenv("ANTHROPIC_API_KEY") ~= nil and os.getenv("ANTHROPIC_API_KEY") ~= ""

-- Configure provider based on API key availability
local provider = has_anthropic_key and "claude" or "copilot"

-- Sonnet 4.5 model name
local model = "claude-sonnet-4-20250514"

local config = {
  provider = provider,
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = model,
      timeout = 30000,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    },
    copilot = {
      model = model,
    },
  },
}

return {
  {
    "yetone/avante.nvim",
    opts = config,
  },
}
