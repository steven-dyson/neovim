return {
  {
    "andythigpen/nvim-coverage",
    version = "*",
    config = function()
      require("coverage").setup({
        auto_reload = true,
        lang = {
          go = {
            coverage_file = "coverage.out", -- relative path – works better here
          },
          python = {
            coverage_file = ".coverage",
            coverage_command = "coverage json --fail-under=0 -q -o -",
          },
        },
      })
    end,
    keys = {
      {
        "<leader>tct",
        function()
          require("coverage").toggle()
        end,
        desc = "Test coverage toggle",
      },
      {
        "<leader>tcs",
        function()
          require("coverage").summary()
        end,
        desc = "Test coverage summary",
      },
      {
        "<leader>tcr",
        function()
          require("coverage").load(true)
        end,
        desc = "Test coverage reload",
      },
    },
  },

  -- Neotest setup
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      { "nvim-treesitter/nvim-treesitter", branch = "main" },
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      {
        "nvim-neotest/neotest-python",
        dependencies = {
          {
            "mfussenegger/nvim-dap-python",
            config = function()
              local dap_python = require("dap-python")
              -- Use virtual environment's python for debugging
              local venv = vim.env.VIRTUAL_ENV
              if venv then
                dap_python.setup(venv .. "/bin/python")
              else
                dap_python.setup(vim.fn.exepath("python3") or "python")
              end
            end,
          },
        },
      },
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        dependencies = {
          { "leoluz/nvim-dap-go", opts = {} },
        },
      },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-golang")({
            go_test_args = {
              "-v",
              "-race",
              "-coverprofile=coverage.out", -- relative path – usually fixes cwd issues
              -- "-covermode=atomic",                -- uncomment if you get weird coverage with -race
              -- "-coverpkg=./...",                  -- uncomment for full module coverage
            },
            env = {
              CGO_ENABLED = "1",
            },
          }),
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG", "--quiet", "--cov" },
            runner = "pytest",
            python = function()
              -- Integrate with venv-selector
              local venv = vim.env.VIRTUAL_ENV
              if venv then
                return venv .. "/bin/python"
              end
              return vim.fn.exepath("python3") or "python"
            end,
          }),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "[t]est [a]ttach",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "[t]est run [f]ile",
      },
      {
        "<leader>tA",
        function()
          -- Now uses the default go_test_args → coverage.out should be created
          require("neotest").run.run({
            suite = true,
            dir = vim.uv.cwd(),
          })
          require("coverage").load(true)
        end,
        desc = "[t]est [A]ll files",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "[t]est [S]uite",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "[t]est [n]earest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "[t]est [l]ast",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "[t]est [s]ummary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "[t]est [o]utput",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "[t]est [O]utput panel",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.stop()
        end,
        desc = "[t]est [t]erminate",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ suite = false, strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug current file",
      },
    },
  },

  -- DAP core
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticHint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "CursorLine" })
    end,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "toggle [d]ebug [b]reakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "[d]ebug [B]reakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "[d]ebug [c]ontinue (start here)",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "[d]ebug [C]ursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "[d]ebug [g]o to line",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "[d]ebug step [o]ver",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "[d]ebug step [O]ut",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "[d]ebug [i]nto",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "[d]ebug [j]ump down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "[d]ebug [k]ump up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "[d]ebug [l]ast",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "[d]ebug [p]ause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "[d]ebug [r]epl",
      },
      {
        "<leader>dR",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "[d]ebug [R]emove breakpoints",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "[d]ebug [s]ession",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "[d]ebug [t]erminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "[d]ebug [w]idgets hover",
      },
      { "<leader>dv", "<cmd>DapViewOpen<cr>", desc = "Open [d]ebug [v]iew" },
      { "<leader>dq", "<cmd>DapViewClose<cr>", desc = "[d]ebug [q]uit view" },
    },
  },

  -- DAP View (UI replacement for dap-ui)
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    opts = {
      windows = {
        position = "right",
        size = 0.3,
      },
    },
  },

  -- Virtual text (shows variable values inline)
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
    },
  },
}
