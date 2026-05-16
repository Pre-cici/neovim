-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",
      -- Installs the debug adapters for you
      "jay-babu/mason-nvim-dap.nvim",

      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      -- Add your own debuggers here

      {
        "mfussenegger/nvim-dap-python",
      -- stylua: ignore
        keys = {
          { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
          { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
        },
        config = function()
          local function get_project_root()
            local root = vim.fs.root(0, {
              ".git",
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "environment.yml",
              "conda.yaml",
            })

            return root or vim.fn.getcwd()
          end

          local function get_python()
            local root = get_project_root()
            local venv_python = root .. "/.venv/bin/python"

            if vim.fn.executable(venv_python) == 1 then
              return venv_python
            end

            local conda = os.getenv("CONDA_PREFIX")
            if conda then
              return conda .. "/bin/python"
            end

            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end

            return "python3"
          end

          require("dap-python").setup(get_python())

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
              env = function()
                local root = get_project_root()
                return {
                  PYTHONPATH = root,
                  TOKENIZERS_PARALLELISM = "false",
                  OC_PYDEVD_RESOLVER = "DISABLE",
                }
              end,
            },

            {
              type = "python",
              request = "launch",
              name = "file:args",
              program = "${file}",
              cwd = get_project_root,
              console = "integratedTerminal",
              justMyCode = true,

              args = function()
                local root = get_project_root()

                -- 让 input 的文件补全以项目根目录为基准
                vim.cmd("lcd " .. vim.fn.fnameescape(root))

                local args = vim.fn.input({
                  prompt = "Arguments: ",
                  completion = "file",
                })

                return require("dap.utils").splitstr(args)
              end,
              env = function()
                local root = get_project_root()
                return {
                  PYTHONPATH = root,
                  TOKENIZERS_PARALLELISM = "false",
                  OC_PYDEVD_RESOLVER = "DISABLE",
                }
              end,
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
            },
          }
        end,
      },
    },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },

    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },

    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },

    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },

    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },

    -- Basic debugging keymaps, feel free to change to your liking!
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue', },
    { "<F6>", function() require("dap").pause() end, desc = "Pause" },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into', },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over', },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out', },

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: See last session result.', },

    { "<F8>", function() require("dap").terminate() end, desc = "Terminate" },
    { "<F9>", function() require("dap").run_last() end, desc = "Run Last" },
  },
    config = function()
      -- Change breakpoint icons
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
        local hl = (type == "Stopped") and "DapStop" or "DapBreak"
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- fancy UI for the debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
    },
    opts = {
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

  -- mason.nvim integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        python = function() end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
