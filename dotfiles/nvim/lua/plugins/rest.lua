return {
  "rest-nvim/rest.nvim",
  ft = { "http" },
  dependencies = { "nvim-lua/plenary.nvim", "j-hui/fidget.nvim" },
  config = function()
    require("rest-nvim").setup({
      request = {
        env_file = { ".env.local", ".env" },
      },
    })
  end,
}
