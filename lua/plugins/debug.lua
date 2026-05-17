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
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",

      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = false,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          virt_text_pos = "eol",
          all_frames = false,
          virt_lines = false,
        },
      },

      {
        "mfussenegger/nvim-dap-python",
        keys = {
          {
            "<leader>dPt",
            function()
              require("dap-python").test_method()
            end,
            desc = "Debug Method",
            ft = "python",
          },
          {
            "<leader>dPc",
            function()
              require("dap-python").test_class()
            end,
            desc = "Debug Class",
            ft = "python",
          },
        },
        config = function()
          local function get_project_root()
            local root = vim.fs.root(0, {
              "uv.lock",
              "pyproject.toml",
              ".git",
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

            local venv = os.getenv("VIRTUAL_ENV")
            if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
              return venv .. "/bin/python"
            end

            local conda = os.getenv("CONDA_PREFIX")
            if conda and vim.fn.executable(conda .. "/bin/python") == 1 then
              return conda .. "/bin/python"
            end

            return "python3"
          end

          local function get_env()
            return {
              TOKENIZERS_PARALLELISM = "false",
              OC_PYDEVD_RESOLVER = "DISABLE",
            }
          end

          -- Adapter Python: 优先使用 Mason 安装的 debugpy
          -- Target Python: 由每个 launch 配置里的 pythonPath 指定为项目 .venv
          local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

          if vim.fn.executable(mason_debugpy) == 1 then
            require("dap-python").setup(mason_debugpy)
          else
            require("dap-python").setup(get_python())
          end

          local dap = require("dap")

          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "file",
              program = "${file}",
              cwd = get_project_root,
              pythonPath = get_python,
              console = "integratedTerminal",
              justMyCode = false,
              env = get_env,
            },

            {
              type = "python",
              request = "launch",
              name = "file:args",
              program = "${file}",
              cwd = get_project_root,
              pythonPath = get_python,
              console = "integratedTerminal",
              justMyCode = false,
              args = function()
                local root = get_project_root()
                vim.cmd("lcd " .. vim.fn.fnameescape(root))

                local args = vim.fn.input({
                  prompt = "Arguments: ",
                  completion = "file",
                })

                return require("dap.utils").splitstr(args)
              end,
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
              pythonPath = get_python,
              console = "integratedTerminal",
              justMyCode = false,
              args = function()
                local root = get_project_root()
                vim.cmd("lcd " .. vim.fn.fnameescape(root))

                local args = vim.fn.input({
                  prompt = "Arguments: ",
                  completion = "file",
                })

                return require("dap.utils").splitstr(args)
              end,
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
              pythonPath = get_python,
              justMyCode = false,
            },
          }
        end,
      },
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
      { "<leader>dU", function() local dapui = require("dapui") dapui.close({}) vim.schedule(function() dapui.open({ reset = true }) end) end, desc = "Dap UI Reset Layout", },
      { "<leader>dr", function() require("dapui").float_element("repl", { enter = true, width = 100, height = 25, position = "center", }) end, desc = "DAP REPL Float", },

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
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "x" },
      },
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
            { id = "console", size = 1.0 },
          },
          size = 8,
          position = "bottom",
        },
      },

      controls = {
        enabled = true,
        element = "console",
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
        max_type_length = 80,
        max_value_lines = 20,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      -- 不自动关闭，避免大量输出、多线程、多进程时窗口闪烁
      -- 手动用 <leader>du 或 F7 关闭
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
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
        "debugpy",
      },
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
}
