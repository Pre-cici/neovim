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
      local opencode_width = function()
        return math.floor(vim.o.columns * 0.35)
      end

      local tmux_pane_id

      local function tmux_available()
        return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
      end

      local function open_builtin_terminal()
        require("opencode.terminal").open(opencode_cmd, {
          split = "right",
          width = opencode_width(),
        })
      end

      local function close_builtin_terminal()
        require("opencode.terminal").close()
      end

      local function toggle_builtin_terminal()
        require("opencode.terminal").toggle(opencode_cmd, {
          split = "right",
          width = opencode_width(),
        })
      end

      local function tmux_pane_exists()
        if not tmux_pane_id then
          return false
        end

        local result = vim.system({ "tmux", "list-panes", "-a", "-F", "#{pane_id}" }, {
          text = true,
        }):wait()
        if result.code ~= 0 then
          tmux_pane_id = nil
          return false
        end

        for _, pane_id in ipairs(vim.split(result.stdout or "", "\n", { trimempty = true })) do
          if pane_id == tmux_pane_id then
            return true
          end
        end

        tmux_pane_id = nil
        return false
      end

      local function open_tmux_pane()
        if tmux_pane_exists() then
          return
        end

        local result = vim.system({
          "tmux",
          "split-window",
          "-h",
          "-d",
          "-P",
          "-F",
          "#{pane_id}",
          "-p",
          "35",
          opencode_cmd,
        }, { text = true }):wait()

        if result.code ~= 0 then
          vim.notify(
            result.stderr ~= "" and result.stderr or "Failed to open tmux pane for opencode",
            vim.log.levels.ERROR,
            { title = "opencode" }
          )
          return
        end

        tmux_pane_id = vim.trim(result.stdout or "")
      end

      local function close_tmux_pane()
        if not tmux_pane_exists() then
          return
        end

        vim.system({ "tmux", "kill-pane", "-t", tmux_pane_id }, { text = true }):wait()
        tmux_pane_id = nil
      end

      local function toggle_tmux_zoom()
        local result = vim.system({ "tmux", "resize-pane", "-Z" }, { text = true }):wait()
        if result.code ~= 0 then
          vim.notify(
            result.stderr ~= "" and result.stderr or "Failed to toggle tmux zoom for opencode",
            vim.log.levels.ERROR,
            { title = "opencode" }
          )
        end
      end

      local function toggle_tmux_pane()
        if tmux_pane_exists() then
          toggle_tmux_zoom()
        else
          open_tmux_pane()
        end
      end

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            if tmux_available() then
              open_tmux_pane()
            else
              open_builtin_terminal()
            end
          end,
          stop = function()
            if tmux_available() then
              close_tmux_pane()
            else
              close_builtin_terminal()
            end
          end,
          toggle = function()
            if tmux_available() then
              toggle_tmux_pane()
            else
              toggle_builtin_terminal()
            end
          end,
        },
      }

      vim.api.nvim_create_autocmd("ExitPre", {
        callback = function()
          if tmux_available() then
            close_tmux_pane()
          end
        end,
      })

      vim.api.nvim_create_user_command("OpencodeStop", function()
        if tmux_available() then
          close_tmux_pane()
        else
          close_builtin_terminal()
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
