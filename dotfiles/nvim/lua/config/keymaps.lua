-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ask questions (buffer or selection)
vim.keymap.set("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante: Ask" })
vim.keymap.set("v", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante: Ask (selection)" })

-- Apply edits
vim.keymap.set("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Avante: Edit" })
vim.keymap.set("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Avante: Edit (selection)" })

-- Re-run last request
vim.keymap.set("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Avante: Refresh" })

-- Stop request
vim.keymap.set("n", "<leader>as", "<cmd>AvanteStop<CR>", { desc = "Avante: Stop" })
