return {
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    -- dependencies = { "michaelb/sniprun" },
    opts = {
      search = {
        mamba_envs = {
          command = "fd '/bin/python$' ~/.local/share/mamba/envs/ --full-path --color never --exclude pkgs",
        },
        homebrew_python = {
          command = "echo /opt/homebrew/bin/python3",
        },
      },
      options = {
        notify_user_on_venv_activation = true,

        set_environment_variables = true,
        activate_venv_in_terminal = true,
        log_level = "DEBUG",
      },
    },
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    config = function(_, opts)
      -- local python_utils = require("utils.python")
      -- python_utils.ensure_pythonpath_autocmd()
      -- python_utils.prepend_env("PYTHONPATH", python_utils.project_root())

      local orig = vim.notify
      require("venv-selector").setup(opts)
      vim.notify = orig
    end,
  },


  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "right",
        bindings = {
          ["k"] = "PrevTask",
          ["j"] = "NextTask",
        },
      },
    },
    keys = {
      { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      {
        "<leader>or",
        function()
          local python = require("utils.python")
          python.run_current_file_task()
        end,
        desc = "Run Python file",
        ft = "python",
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
    end,
  },

  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>lm", "<cmd>Leet<cr>", desc = "LeetCode Menu" },
      { "<leader>ll", "<cmd>Leet list<cr>", desc = "LeetCode List" },
      { "<leader>lr", "<cmd>Leet run<cr>", desc = "LeetCode Run" },
      { "<leader>ls", "<cmd>Leet submit<cr>", desc = "LeetCode Submit" },
      { "<leader>lc", "<cmd>Leet console<cr>", desc = "LeetCode Console" },
      { "<leader>lf", "<cmd>Leet info<cr>", desc = "LeetCode Info" },
      { "<leader>li", "<cmd>Leet inject<cr>", desc = "LeetCode Inject" },
    },
    opts = {
      lang = "python3",

      cn = { -- leetcode.cn
        enabled = true, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
      },

      injector = { ---@type table<lc.lang, lc.inject>
        ["python3"] = {
          imports = function()
            return { "from typing import List" }
          end,
        },
      },

    },
  },
}
