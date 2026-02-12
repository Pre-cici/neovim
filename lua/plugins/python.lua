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
}
