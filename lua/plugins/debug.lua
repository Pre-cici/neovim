-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
return {
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    opts = {
      show_stop_reason = false,
      virt_text_pos = "eol",
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local python_utils = require("utils.python")

      local function get_project_root()
        return python_utils.project_root(0)
      end

      local function get_env()
        return {
          TOKENIZERS_PARALLELISM = "false",
          OC_PYDEVD_RESOLVER = "DISABLE",
        }
      end

      local function get_args()
        local args = vim.fn.input({
          prompt = "Arguments: ",
          completion = "file",
        })

        return require("dap.utils").splitstr(args)
      end

      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local dap_python = require("dap-python")

      if vim.fn.executable(mason_debugpy) == 1 then
        dap_python.setup(mason_debugpy)
      else
        dap_python.setup(python_utils.active_python(0))
      end
      dap_python.resolve_python = function()
        return python_utils.active_python(0)
      end

      local dap = require("dap")

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "file",
          program = "${file}",
          cwd = get_project_root,
          console = "integratedTerminal",
          justMyCode = true,
          env = get_env,
        },

        {
          type = "python",
          request = "launch",
          name = "file:args",
          program = "${file}",
          cwd = get_project_root,
          console = "integratedTerminal",
          justMyCode = true,
          args = get_args,
          env = get_env,
        },

        {
          type = "python",
          request = "launch",
          name = "module:args",
          module = function()
            return vim.fn.input("Module: ")
          end,
          cwd = get_project_root,
          console = "integratedTerminal",
          justMyCode = true,
          args = get_args,
          env = get_env,
        },

        {
          type = "python",
          request = "attach",
          name = "attach",
          connect = function()
            local host = vim.fn.input("Host [127.0.0.1]: ")
            host = host ~= "" and host or "127.0.0.1"

            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678

            return {
              host = host,
              port = port,
            }
          end,
          cwd = get_project_root,
          justMyCode = true,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },

      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },

      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line No Execute" },

      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },

      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Widget" },

      { "<F5>", function() require("dap").continue() end, desc = "Debug Start/Continue" },
      { "<F6>", function() require("dap").pause() end, desc = "Debug Pause" },
      { "<F1>", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<F2>", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<F3>", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<F7>", function() require("dapui").toggle({}) end, desc = "Debug UI Toggle" },
      { "<F8>", function() require("dap").terminate() end, desc = "Debug Terminate" },
      { "<F9>", function() require("dap").run_last() end, desc = "Debug Run Last" },
    },

    config = function()
      vim.api.nvim_set_hl(0, "DapBreak", { fg = "#ED8092" })
      vim.api.nvim_set_hl(0, "DapStop", { fg = "#F5A97F" })

      local breakpoint_icons = {
        Breakpoint = "",
        BreakpointCondition = "",
        BreakpointRejected = "",
        LogPoint = "",
        Stopped = "",
      }

      for type, icon in pairs(breakpoint_icons) do
        local tp = "Dap" .. type
        local hl = type == "Stopped" and "DapStop" or "DapBreak"
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "x" }, },
      { "<leader>dr", function() require("dapui").close({}) vim.schedule(function() require("dapui").open({ reset = true }) end) end, desc = "Dap UI Reset Layout", },
      { "<leader>do", function() require("dapui").float_element("console", { enter = true, width = 100, height = 25, position = "center", }) end, desc = "DAP Console Float", },
    },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.45 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.20 },
            { id = "breakpoints", size = 0.10 },
          },
          size = 45,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1.0 },
          },
          size = 8,
          position = "bottom",
        },
      },

      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = " F6",
          play = " F5",
          step_into = " F1",
          step_over = " F2",
          step_out = " F3",
          terminate = " F8",
          step_back = " ",
          run_last = " F9",
          disconnect = " ",
        },
      },

      floating = {
        max_height = 0.75,
        max_width = 0.75,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },

      render = {
        max_type_length = 60,
        max_value_lines = 6,
        indent = 2,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {
        python = function() end,
      },
      ensure_installed = {
        "python",
      },
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
}
