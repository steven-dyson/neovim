return {
  "steven-dyson/todo-finder.nvim",
  -- dir = "~/Code/todo.nvim",
  branch = "main",
  cmd = "ListTodos",
  keys = function()
    local keys = {
      {
        "<leader>T",
        function()
          require("todo-finder").list_todos()
        end,
        desc = "Open todos",
      },
    }
    return keys
  end,
  config = function()
    require("todo-finder").setup({
      exclude_dirs = {
        ["node_modules"] = true,
        [".git"] = true,
        [".cache"] = true,
        ["target"] = true,
        ["build"] = true,
        ["dist"] = true,
        ["venv"] = true,
        ["__pycache__"] = true,
      },
      colors = {
        flag = { fg = "#000000", bg = "#40E0D0", bold = true },
        text = { fg = "#40E0D0" },
        active = { fg = "#FFAF5F" },
      },
    })
  end,
}
