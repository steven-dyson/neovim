return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers.bashls = {}

    opts.servers.tailwindcss = vim.tbl_deep_extend("force", opts.servers.tailwindcss or {}, {
      filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "templ", "astro" },
      init_options = {
        userLanguages = {
          templ = "html",
        },
      },
    })

    -- Disable sqruff LSP auto-attachment
    opts.servers.sqruff = { enabled = false }

    opts.servers.postgres_language_server = {
      cmd = { "postgres-language-server", "lsp-proxy" },
      filetypes = { "sql", "pgsql", "plpgsql" },
      root_markers = {
        ".git",
        "docker-compose.yml",
        "docker-compose.yaml",
        "Makefile",
        ".sqlfluff",
        "pyproject.toml",
      },
      single_file_support = true,
      settings = {},
    }
  end,
}
