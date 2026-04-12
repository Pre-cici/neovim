return {
  {
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      {
        "folke/snacks.nvim",
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
          terminal = {},
        },
      },
    },
    config = function()
      local opencode_cmd = "opencode --port"
      local opencode_utils = require("utils.opencode")
      local opencode_width = function()
        return math.floor(vim.o.columns * 0.35)
      end

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = opencode_utils.server_opts(opencode_cmd, opencode_width),
      }

      vim.api.nvim_create_autocmd("ExitPre", {
        callback = function()
          if opencode_utils.tmux_available() then
            opencode_utils.close_tmux_pane()
          end
        end,
      })

      vim.api.nvim_create_user_command("OpencodeStop", function()
        if opencode_utils.tmux_available() then
          opencode_utils.close_tmux_pane()
        else
          opencode_utils.close_builtin_terminal(opencode_cmd, opencode_width)
        end
      end, { desc = "Stop opencode" })

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode…" })

      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "t" }, "<leader>ac", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { desc = "Add range to opencode", expr = true })

      vim.keymap.set("n", "go", function()
        return require("opencode").operator("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<A-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "Scroll opencode up" })

      vim.keymap.set("n", "<A-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "Scroll opencode down" })
    end,
  },
}
