local terminal_utils = require("utils.terminal")

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      if vim.fn.argc() > 0 then
        return
      end

      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      local function footer()
        local stats = require("lazy").stats()
        local loaded = stats.loaded or 0
        local total = stats.count or loaded
        local deferred = math.max(total - loaded, 0)
        return string.format("%.2f ms startup, %d loaded, %d deferred", stats.startuptime or 0, loaded, deferred)
      end

      dashboard.section.header.val = {
        "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██║   ██║██║████╗ ████║",
        "██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene<cr>"),
        dashboard.button("f", "  Find file", function()
          Snacks.picker.files({ layout = { preset = "telescope" }, cwd = vim.uv.cwd() })
        end),
        dashboard.button("r", "  Recent files", function()
          Snacks.picker.recent({ layout = { preset = "telescope" }, cwd = vim.uv.cwd() })
        end),
        dashboard.button("p", "  Projects", function()
          Snacks.picker.projects({ layout = { preset = "select" } })
        end),
        dashboard.button("s", "󰁯  Restore session", function()
          require("persistence").load()
        end),
        dashboard.button("L", "󰈸  LeetCode", "<cmd>Leet<cr>"),
        dashboard.button("c", "  Open config", "<cmd>Oil ~/.config/nvim<cr>"),
        dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      dashboard.section.footer.val = { footer() }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "VeryLazy",
        callback = function()
          dashboard.section.footer.val = { footer() }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        indent = { char = "" },
        animate = { enabled = false },
        scope = { char = "│", only_current = true },
        chunk = {
          enabled = true,
          only_current = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = "─",
          },
        },
      },
      statuscolumn = { folds = { open = true, git_hl = true } },
    },
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      bottom = {
        {
          ft = "snacks_terminal",
          filter = function(buf)
            return not terminal_utils.snacks_terminal_cmd_starts_with(buf, "opencode --port")
              and not terminal_utils.snacks_terminal_cmd_starts_with(buf, "lazygit")
          end,
          size = { height = 0.3 },
          title = "Terminal",
        },
      },
      right = {
        {
          ft = "snacks_terminal",
          filter = function(buf)
            return terminal_utils.snacks_terminal_cmd_starts_with(buf, "opencode --port")
          end,
          size = { width = 0.35 },
          title = "Opencode",
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = function()
      local enable_conceal = false -- Hide command text if true
      return {
        cmdline = {
          view = "cmdline", -- The kind of popup used for :
          format = {
            cmdline = { icon = "", conceal = enable_conceal },
            search_down = { conceal = enable_conceal },
            search_up = { conceal = enable_conceal },
            filter = { conceal = enable_conceal },
            lua = { conceal = enable_conceal },
            help = { conceal = enable_conceal },
            input = { conceal = enable_conceal },
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },

        messages = {
          enabled = true,
          view = "mini",
        },

        lsp = {
          hover = { enabled = false },
          signature = { enabled = false },
          progress = { enabled = false },
          message = { enabled = false },
          smart_move = { enabled = false },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { '<leader>nl', function() require('noice').cmd 'last' end, desc = 'Noice Last Message', },
      { '<leader>nn', function() require('noice').cmd 'all' end, desc = 'Noice All', },
      { '<leader>nd', function() require('noice').cmd 'dismiss' end, desc = 'Dismiss All', },
      { '<leader>nm', ':messages <CR>', desc = 'Messages', },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPre",
  },

  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },

  {
    "lukas-reineke/virt-column.nvim",
    event = "BufReadPre",
    opts = {
      char = "⋮", -- "|", "", "┇", "∶", "∷", "║", "", "󰮾",
      virtcolumn = "120",
    },
  },

  {
    "tummetott/reticle.nvim",
    event = "BufReadPre",
    opts = {
      always_highlight_number = true,
      ignore = {
        cursorline = {
          "Trouble",
          "snacks_picker_list",
          "snacks_picker_input",
        },
        cursorcolumn = {},
      },
    },
  },
}
