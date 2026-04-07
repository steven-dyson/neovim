return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("conform.util")

    -- Helper to detect sqlfluff config in project root
    local function has_sqlfluff_config()
      return util.root_file({
        ".sqlfluff",
        "pyproject.toml",
        "setup.cfg",
      }) ~= nil
    end

    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
          return false
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
      ["templ_tool"] = {
        command = "go",
        args = { "tool", "templ", "fmt", "$FILENAME" },
        stdin = false,
        condition = function(_, ctx)
          return vim.bo[ctx.buf].filetype == "templ" or ctx.filename:match("%.templ$")
        end,
      },
      ["sqlfluff"] = {
        args = { "format", "--dialect", "postgres", "-" },
      },
      ["sqruff"] = {
        args = { "fmt", "--dialect", "postgres", "-" },
      },
    })

    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      lua = { "stylua" },
      python = { "ruff_format" },
      javascript = { "prettier", stop_after_first = true },
      javascriptreact = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      typescriptreact = { "prettier", stop_after_first = true },
      svelte = { "prettier", stop_after_first = true },
      astro = { "prettier", stop_after_first = true },
      css = { "prettier", stop_after_first = true },
      scss = { "prettier", stop_after_first = true },
      less = { "prettier", stop_after_first = true },
      html = { "prettier", stop_after_first = true },
      json = { "prettier", stop_after_first = true },
      jsonc = { "prettier", stop_after_first = true },
      yaml = { "prettier", stop_after_first = true },
      markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" },
      toml = { "taplo" },
      go = { "gofumpt", "goimports" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      sql = function(bufnr)
        if has_sqlfluff_config() then
          return { "sqlfluff" }
        else
          return { "sqruff" }
        end
      end,
      templ = { "templ_tool" },
    })
  end,
}
