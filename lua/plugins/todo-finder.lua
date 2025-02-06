return {
  "steven-dyson/todo-finder.nvim",
  dir = "~/Code/todo-finder.nvim",
  branch = "main",
  -- tag = "0.3.0",
  cmd = "ListTodos",
  dependencies = { "folke/which-key.nvim" },
  keys = function()
    local keys = {
      {
        "<leader>T",
        function()
          require("todo-finder").list_todos()
        end,
        desc = "Open todos",
      },
    }
    return keys
  end,
  init = function()
    require("todo-finder").setup({
      exclude_dirs = {
        ["node_modules"] = true,
        [".git"] = true,
        [".cache"] = true,
        ["target"] = true,
        ["build"] = true,
        ["dist"] = true,
        ["venv"] = true,
        ["__pycache__"] = true,
      },
      colors = {
        flag = { fg = "#000000", bg = "#40E0D0", bold = true },
        flagHidden = { fg = "#40E0D0", bg = "#40E0D0" },
        text = { fg = "#40E0D0" },
        active = { fg = "#FFAF5F" },
      },
      comment_definitions = {
        ["js_like"] = {
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          comments = {
            { open = "%/%/", close = "" }, -- Single-line
            { open = "%/%*", close = "%*%/" }, -- Multi-line
          },
        },
        ["html_like"] = {
          filetypes = { "html", "xml" },
          comments = {
            { open = "%<%!--", close = "--%>" }, -- Multi-line
          },
        },
        ["css"] = {
          filetypes = { "css" },
          comments = {
            { open = "%/%*", close = "%*%/" }, -- Multi-line
          },
        },
        ["js_frameworks"] = {
          filetypes = { "astro", "vue", "svelte" },
          comments = {
            { open = "%/%/", close = "" }, -- JS single-line
            { open = "%/%*", close = "%*%/" }, -- JS multi-line
            { open = "%<%!--", close = "--%>" }, -- HTML style
          },
        },
        ["go"] = {
          filetypes = { "go" },
          comments = {
            { open = "%/%/", close = "" }, -- Single-line
            { open = "%/%*", close = "%*%/" }, -- Multi-line
          },
        },
        ["py_like"] = {
          filetypes = { "python", "sh", "bash" },
          comments = {
            { open = "%#", close = "" }, -- Single-line
            { open = [[''']], close = [[''']] }, -- Multiline
            { open = [["""]], close = [["""]] }, -- Multiline
          },
        },
        ["yaml_like"] = {
          filetypes = { "yaml", "toml" },
          comments = {
            { open = "%#", close = "" }, -- Single-line for YAML and TOML
          },
        },
        ["lua"] = {
          filetypes = { "lua" },
          comments = {
            { open = "%-%-", close = "" }, -- Single-line
            { open = "--%[%[", close = "%]%]--" }, -- Multi-line
          },
        },
        ["rust"] = {
          filetypes = { "rust" },
          comments = {
            { open = "%/%/", close = "" }, -- Single-line
            { open = "/%*", close = "%*%/" }, -- Multi-line
          },
        },
        ["elixir"] = {
          filetypes = { "elixir" },
          comments = {
            { open = "%#", close = "" }, -- Single-line
            { open = [["""]], close = [["""]] }, -- Multi-line
          },
        },
        ["zig"] = {
          filetypes = { "zig" },
          comments = {
            { open = "%/%/", close = "" }, -- Single-line
            { open = "%/%*", close = "%*%/" }, -- Multi-line
          },
        },
      },
    })
  end,
}
