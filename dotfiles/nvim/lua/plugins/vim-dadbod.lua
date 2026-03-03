return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    { "<leader>D", group = "Database" },
    { "<leader>Du", "<cmd>DBUI<CR>", desc = "Open UI" },
    { "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Find Buffer" },
    { "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", desc = "Rename Buffer" },
    -- Run current statement (normal mode)
    { "<leader>De", "<cmd>DB<CR>", desc = "Execute SQL" },

    -- Run selected SQL (visual mode)
    { "<leader>De", "<Plug>(DBExecute)", mode = "v", desc = "Execute Selected SQL" },
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
