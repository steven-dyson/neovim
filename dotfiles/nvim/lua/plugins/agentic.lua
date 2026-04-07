return {
  "carlos-algms/agentic.nvim",

  opts = {
    -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp"
    provider = "codex-acp", -- setting the name here is all you need to get started
    acp_providers = {
      ["codex-acp"] = {
        command = "codex-acp",
        args = {
          "-c",
          'model_reasoning_effort="medium"',
          "-c",
          'model_verbosity="low"',
          "-c",
          'personality="pragmatic"',
          "-c",
          'approval_policy="on-request"',
          "-c",
          'sandbox_mode="workspace-write"',
          "-c",
          'plan_mode_reasoning_effort="high"',
          "-c",
          'service_tier="fast"',
          "-c",
          'web_search="live"',
        },
      },
      ["opencode-acp"] = {
        command = "opencode",
        args = { "acp" },
      },
    },
  },

  -- these are just suggested keymaps; customize as desired
  keys = {
    {
      "<leader>aa",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<leader>ac",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic to Context",
    },
    {
      "<leader>ap",
      function()
        require("agentic").switch_provider()
      end,
      mode = { "n", "v" },
      desc = "Switch to a different provider",
    },

    {
      "<leader>an",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v" },
      desc = "New Agentic Session",
    },
    {
      "<leader>ar", -- ai Restore
      function()
        require("agentic").restore_session()
      end,
      desc = "Agentic Restore session",
      silent = true,
      mode = { "n", "v" },
    },
    {
      "<leader>ad", -- ai Diagnostics
      function()
        require("agentic").add_current_line_diagnostics()
      end,
      desc = "Add current line diagnostic to Agentic",
      mode = { "n" },
    },
    {
      "<leader>aD", -- ai all Diagnostics
      function()
        require("agentic").add_buffer_diagnostics()
      end,
      desc = "Add all buffer diagnostics to Agentic",
      mode = { "n" },
    },
  },
}
