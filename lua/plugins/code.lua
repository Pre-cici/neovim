return {
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    dependencies = { "michaelb/sniprun" },
    opts = {
      options = {
        notify_user_on_venv_activation = true,

        set_environment_variables = true,
        activate_venv_in_terminal = true,
        on_venv_activate_callback = function()
          local py = require("venv-selector").python()
          if not py or py == "" then
            return
          end

          -- Update sniprun interpreter to selected venv python
          local ok, sniprun = pcall(require, "sniprun")
          if ok then
            sniprun.setup({
              selected_interpreters = { "Python3_original" },
              repl_enable = { "Python3_original" },
              interpreter_options = {
                Python3_original = { interpreter = py },
              },
            })
          end
        end,
      },
    },
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    config = function(_, opts)
      -- Add project root to PYTHONPATH so SnipRun can import local packages
      local function project_root()
        local buf = vim.api.nvim_buf_get_name(0)
        local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.loop.cwd()
        local markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" }
        local found = vim.fs.find(markers, { path = start, upward = true })[1]
        return found and vim.fs.dirname(found) or vim.loop.cwd()
      end

      local function prepend_env(name, value)
        local sep = ":"
        local cur = vim.env[name] or ""
        if cur == "" then
          vim.env[name] = value
          return
        end
        for entry in string.gmatch(cur, "([^" .. sep .. "]+)") do
          if entry == value then
            return
          end
        end
        vim.env[name] = value .. sep .. cur
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = "*.py",
        callback = function()
          prepend_env("PYTHONPATH", project_root())
        end,
      })

      local orig = vim.notify
      require("venv-selector").setup(opts)
      vim.notify = orig
    end,
  },
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
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = {
      -- {
      --   -- see the image.nvim readme for more information about configuring this plugin
      --   "3rd/image.nvim",
      --   opts = {
      --     backend = "kitty", -- whatever backend you would like to use
      --     max_width = 100,
      --     max_height = 12,
      --     max_height_window_percentage = math.huge,
      --     max_width_window_percentage = math.huge,
      --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      --     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      --   },
      -- },
      {
        "folke/snacks.nvim",
        opts = {
          image = {
            enabled = true,
            doc = {
              enabled = true,
              inline = false,
              max_width = 100,
              max_height = 100,
            },
          },
        },
      },
    },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "snacks.nvim"
      vim.g.molten_output_win_max_height = 20
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
    {
    "kawre/leetcode.nvim",
    -- cmd = "Leet",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      ---@type string
      arg = "leetcode.nvim",

      ---@type lc.lang
      lang = "cpp",

      cn = { -- leetcode.cn
        enabled = true, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
      },

      ---@type lc.storage
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },

      ---@type table<string, boolean>
      plugins = {
        non_standalone = false,
      },

      ---@type boolean
      logging = true,

      injector = {}, ---@type table<lc.lang, lc.inject>

      cache = {
        update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
      },

      editor = {
        reset_previous_code = true, ---@type boolean
        fold_imports = true, ---@type boolean
      },

      console = {
        open_on_runcode = true, ---@type boolean

        dir = "row", ---@type lc.direction

        size = { ---@type lc.size
          width = "90%",
          height = "75%",
        },

        result = {
          size = "60%", ---@type lc.size
        },

        testcase = {
          virt_text = true, ---@type boolean

          size = "40%", ---@type lc.size
        },
      },

      description = {
        position = "left", ---@type lc.position

        width = "40%", ---@type lc.size

        show_stats = true, ---@type boolean
      },

      ---@type lc.picker
      picker = { provider = nil },

      hooks = {
        ---@type fun()[]
        ["enter"] = {},

        ---@type fun(question: lc.ui.Question)[]
        ["question_enter"] = {},

        ---@type fun()[]
        ["leave"] = {},
      },

      keys = {
        toggle = { "q" }, ---@type string|string[]
        confirm = { "<CR>" }, ---@type string|string[]

        reset_testcases = "r", ---@type string
        use_testcase = "U", ---@type string
        focus_testcases = "H", ---@type string
        focus_result = "L", ---@type string
      },

      ---@type lc.highlights
      theme = {},

      ---@type boolean
      image_support = false,
    },
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
