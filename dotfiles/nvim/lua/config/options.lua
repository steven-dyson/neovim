-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = false -- Use tabs instead of spaces
vim.opt.tabstop = 4 -- Number of spaces that a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"

-- Use spaces and 2-space indents for json, yaml, toml, etc.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "yaml", "toml" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Use spaces and 4-space indents for python
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
