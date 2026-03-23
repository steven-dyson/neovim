-- REST API requests
vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<CR>", { desc = "Rest: Send request" })
vim.keymap.set("n", "<leader>rp", "<cmd>Rest run pretty<CR>", { desc = "Rest: Send request (pretty print)" })
vim.keymap.set("n", "<leader>rl", "<cmd>Rest run last<CR>", { desc = "Rest: Send last request" })
vim.keymap.set("n", "<leader>rh", "<cmd>Rest history<CR>", { desc = "Rest: Open history" })
