return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint-cli2" },
      go = { "golangcilint" },
      env = { "dotenv_linter" },
    },
  },
}
