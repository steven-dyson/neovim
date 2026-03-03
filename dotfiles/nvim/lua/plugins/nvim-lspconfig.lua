return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics
    opts.servers.bashls = vim.tbl_deep_extend("force", opts.servers.bashls or {}, {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, res, ...)
          local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ":t")
          if string.match(file_name, "^%.env") == nil then
            return on_publish_diagnostics(err, res, ...)
          end
        end,
      },
    })

    opts.servers.tailwindcss = vim.tbl_deep_extend("force", opts.servers.tailwindcss or {}, {
      filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "templ" },
      init_options = {
        userLanguages = {
          templ = "html",
        },
      },
    })

    -- Disable sqruff LSP auto-attachment
    opts.servers.sqruff = { enabled = false }

    -- Manual config for postgres-language-server
    local lspconfig = require("lspconfig")
    lspconfig.postgres_language_server = {
      default_config = {
        cmd = { "postgres-language-server", "--stdio" },
        filetypes = { "sql", "pgsql", "plpgsql" },
        root_dir = lspconfig.util.root_pattern(
          ".git",
          "docker-compose.yml",
          "docker-compose.yaml",
          "Makefile",
          ".sqlfluff",
          "pyproject.toml"
        ) or vim.fs.dirname, -- ← fixed deprecation here
        single_file_support = true,
        settings = {},
      },
    }

    -- Optional: Auto-start on SQL filetypes (if not attaching automatically)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "pgsql", "plpgsql" },
      callback = function()
        vim.lsp.start("postgres_language_server")
      end,
    })
  end,
}
