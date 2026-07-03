return {
  {
    "andythigpen/nvim-coverage",
    version = "*",
    config = function()
      require("coverage").setup({
        auto_reload = true,
        lang = {
          go = {
            coverage_file = "coverage.out",
          },
          python = {
            coverage_file = ".coverage",
            coverage_command = "coverage json --fail-under=0 -q -o -",
          },
          vitest = {
            coverage_file = "coverage/lcov.info",
            coverage_command = "vitest run --coverage",
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
        desc = "Test Coverage Toggle",
      },
      {
        "<leader>tcs",
        function()
          require("coverage").summary()
        end,
        desc = "Test Coverage Summary",
      },
      {
        "<leader>tcr",
        function()
          require("coverage").load(true)
        end,
        desc = "Test Coverage Reload",
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
      "marilari88/neotest-vitest",
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
      local golang_adapter = require("neotest-golang")({
        go_test_args = {
          "-v",
          "-count=1", -- prevent test caching
          "-coverprofile=coverage.out",
        },
      })

      golang_adapter.root = function(dir)
        local go_root = vim.fs.find({ "go.work", "go.mod" }, {
          path = dir,
          upward = false,
        })[1]
        if not go_root then
          return nil
        end
        return vim.fs.dirname(go_root)
      end

      return {
        adapters = {
          golang_adapter,
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
          require("neotest-vitest")({
            args = { "--coverage" },
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
        desc = "Test Attach",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test Run File",
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
        desc = "Test All Files (with coverage)",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "Test Suite",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test Output Panel",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test Terminate",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ suite = false, strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ suite = false, vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug Current File",
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
        desc = "Toggle Debug Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug Breakpoint Condition",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Debug Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Debug Run To Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Debug Go To Line",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Debug Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Debug Step Out",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Debug Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Debug Jump Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Debug Jump Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug Last",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Debug Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Debug Repl",
      },
      {
        "<leader>dR",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Debug Remove Breakpoints",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Debug Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Debug Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Debug Widgets Hover",
      },
      { "<leader>dv", "<cmd>DapViewOpen<cr>", desc = "Open Debug View" },
      { "<leader>dq", "<cmd>DapViewClose<cr>", desc = "Debug Quit View" },
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
