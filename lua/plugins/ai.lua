return {
  {
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim" },
    },
    config = function()
      local opencode_utils = require("utils.opencode")
      local opencode_width = function()
        return math.floor(vim.o.columns * 0.35)
      end
      local socket = assert(vim.uv.new_tcp())
      assert(socket:bind("127.0.0.1", 0))
      local opencode_port = assert(socket:getsockname()).port
      local release_port = function()
        if not socket:is_closing() then
          socket:close()
        end
      end
      local opencode_cmd = ("opencode --port %d"):format(opencode_port)
      local opencode_url = ("http://localhost:%d"):format(opencode_port)

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = opencode_utils.server_opts(opencode_cmd, opencode_width, opencode_url, release_port),
        events = {
          reload = true,
          permissions = {
            enabled = false,
            edits = {
              enabled = false,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("ExitPre", {
        callback = function()
          release_port()
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
        require("opencode").ask("@this: ")
      end, { desc = "Ask opencode @this…" })

      vim.keymap.set({ "n", "x" }, "<leader>ap", function()
        require("opencode").ask("")
      end, { desc = "Ask opencode…" })

      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "t" }, "<leader>ac", function()
        release_port()
        if opencode_utils.tmux_available() then
          opencode_utils.toggle_tmux_pane(opencode_cmd)
        else
          opencode_utils.toggle_builtin_terminal(opencode_cmd, opencode_width)
        end

        require("opencode.server.discovery")
          .get()
          :catch(function(err)
            if err then
              vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
            end
          end)
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
