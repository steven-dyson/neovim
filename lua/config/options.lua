-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = false -- Use tabs instead of spaces
vim.opt.tabstop = 4 -- Number of spaces that a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
