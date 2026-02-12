return {
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",

    keys = {
      -- Run current line / visual selection (recommended to use <Plug>)
      { "<leader>cr", "<Plug>SnipRun", desc = "SnipRun: run snippet", mode = { "n", "v" } },
      { "<leader>cc", "<Plug>SnipRun", desc = "SnipRun: run snippet", mode = { "v" } },

      -- Run whole file
      {
        "<leader>cc",
        function()
          -- Keep cursor position while running the whole file
          local view = vim.fn.winsaveview()
          vim.cmd("%SnipRun")
          vim.fn.winrestview(view)
        end,
        desc = "SnipRun: run file",
        mode = "n",
      },

      -- Stop/kill the running job (infinite loop, etc.)
      { "<leader>cR", "<cmd>SnipReset<cr>", desc = "SnipRun: reset/stop", mode = "n" },
    },

    config = function()
      require("sniprun").setup({
        display = { "Terminal" },
        display_options = {
          -- terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
          terminal_line_number = false, -- whether show line number in terminal window
          terminal_signcolumn = false, -- whether show signcolumn in terminal window
          terminal_position = "horizontal", --# or "horizontal", to open as horizontal split instead of vertical split
          terminal_width = 45, --# change the terminal display option width (if vertical)
          terminal_height = 10, --# change the terminal display option height (if horizontal)
        },

        selected_interpreters = { "Python3_original" },

        interpreter_options = {
          Python3_original = {
            -- Use a specific python executable if you want
            interpreter = "python3",
          },
        },
      })
    end,
  },

  {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    opts = {
      dap = false,
      task_list = {
        direction = "right",
        bindings = {
          ["o"] = false,
          ["+"] = "IncreaseDetail",
          ["_"] = "DecreaseDetail",
          ["="] = "IncreaseAllDetail",
          ["-"] = "DecreaseAllDetail",
          ["k"] = "PrevTask",
          ["j"] = "NextTask",
          ["t"] = "<CMD>OverseerQuickAction open tab<CR>",
          ["<C-u>"] = false,
          ["<C-d>"] = false,
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
        },
      },
      form = {
        win_opts = {
          winblend = 0,
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
    },
    keys = {
      { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
      { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
    },
    config = function()
      local overseer = require("overseer")
      -- overseer.config
      overseer.setup({
        template_timeout = 8000,
        templates = { -- Templated defined inside ~/.config/nvim/lua/overseer/template
          "builtin",
          "condor",
          "python",
          "grun_option",
          "run_script",
        },
        component_aliases = {
          default = {
            { "display_duration", detail_level = 1 },
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
          },
          default_vscode = {
            "default",
            "display_duration",
            "task_list_on_start",
            "on_output_quickfix",
            "unique",
          },
        },
      })
      -- overseer template hooks
      overseer.add_template_hook({
        module = "^make$",
      }, function(task_defn, util)
        util.add_component(task_defn, "task_list_on_start")
        util.add_component(task_defn, { "on_output_write_file", filename = task_defn.cmd[1] .. ".log" })
        util.add_component(task_defn, { "on_output_quickfix", open_on_exit = "failure" })
        util.add_component(task_defn, "on_complete_notify")
        util.add_component(task_defn, { "display_duration", detail_level = 1 })
        util.add_component(task_defn, "unique")
        util.remove_component(task_defn, "on_output_summarize")
      end)

      overseer.add_template_hook({
        module = "^remake Fit$",
      }, function(task_defn, util)
        util.add_component(task_defn, "unique")
      end)
    end,
  },

  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       title = "Overseer",
  --       ft = "OverseerList",
  --       open = function()
  --         require("overseer").open()
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts = opts or {}
  --     opts.consumers = opts.consumers or {}
  --     opts.consumers.overseer = require("neotest.consumers.overseer")
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   opts = function()
  --     require("overseer").enable_dap()
  --   end,
  -- },
}
