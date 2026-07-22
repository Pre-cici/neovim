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

      local function set_dashboard_highlights()
        local colors
        if vim.g.colors_name and vim.g.colors_name:match("^rose%-pine") then
          local palette = require("rose-pine.palette")
          colors = {
            mauve = palette.iris,
            lavender = palette.foam,
            blue = palette.foam,
            sapphire = palette.pine,
            teal = palette.rose,
            subtext0 = palette.muted,
            subtext1 = palette.subtle,
            peach = palette.gold,
            green = palette.leaf,
            red = palette.love,
            overlay0 = palette.muted,
          }
        else
          colors = require("catppuccin.palettes").get_palette()
        end
        local highlights = {
          DashboardLogo1 = { fg = colors.mauve, bold = true },
          DashboardLogo2 = { fg = colors.lavender, bold = true },
          DashboardLogo3 = { fg = colors.blue, bold = true },
          DashboardLogo4 = { fg = colors.sapphire, bold = true },
          DashboardLogo5 = { fg = colors.teal, bold = true },
          DashboardFrameAccent = { fg = colors.sapphire, bold = true },
          DashboardTitle = { fg = colors.lavender, bold = true },
          DashboardPath = { fg = colors.subtext0, italic = true },
          DashboardButton = { fg = colors.subtext1 },
          DashboardShortcut = { fg = colors.peach, bold = true },
          DashboardIconBlue = { fg = colors.blue },
          DashboardIconGreen = { fg = colors.green },
          DashboardIconMauve = { fg = colors.mauve },
          DashboardIconPeach = { fg = colors.peach },
          DashboardIconRed = { fg = colors.red },
          DashboardIconTeal = { fg = colors.teal },
          DashboardFooter = { fg = colors.overlay0, italic = true },
        }

        for name, opts in pairs(highlights) do
          vim.api.nvim_set_hl(0, name, opts)
        end
      end

      set_dashboard_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("dashboard_highlights", { clear = true }),
        callback = set_dashboard_highlights,
      })

      local function button(shortcut, icon, label, action, icon_hl)
        local item = dashboard.button(shortcut, icon .. "  " .. label, type(action) == "string" and action or nil)
        if type(action) == "function" then
          item.on_press = action
          item.opts.keymap = { "n", shortcut, action, { noremap = true, silent = true, nowait = true } }
        end
        item.opts.hl = {
          { icon_hl, 0, #icon },
          { "DashboardButton", #icon, -1 },
        }
        item.opts.hl_shortcut = "DashboardShortcut"
        return item
      end

      local function plugin_summary()
        local stats = require("lazy").stats()
        local loaded = stats.loaded or 0
        local total = stats.count or loaded
        return string.format("󰏖  %d/%d plugins loaded  ·  󰔟 %.2f ms", loaded, total, stats.startuptime or 0)
      end

      local banner_width = 69
      local function banner_rule(left, label, right)
        local text = " " .. label .. " "
        local fill = banner_width - vim.fn.strdisplaywidth(text) - 2
        local left_fill = math.floor(fill / 2)
        return left .. string.rep("─", left_fill) .. text .. string.rep("─", fill - left_fill) .. right
      end

      local logo_lines = {
        [=[ __        ______  ____  __ __  _____ __  ______  ____ ]=],
        [=[ \ \      / / __ \/ __ \/ //_/ / ___// / / / __ \/ __ \]=],
        [=[  \ \ /\ / / / / / /_/ / ,<    \__ \/ /_/ / / / / /_/ /]=],
        [=[   \ V  V / /_/ / _, _/ /| |  ___/ / __  / /_/ / ____/]=],
        [=[    \_/\_/\____/_/ |_/_/ |_| /____/_/ /_/\____/_/]=],
        [=[                                                 ]=],
      }
      local logo_width = 0
      for _, line in ipairs(logo_lines) do
        logo_width = math.max(logo_width, vim.fn.strdisplaywidth(line))
      end
      local logo_indent = math.floor((banner_width - logo_width) / 2)

      local function banner_text(line)
        local padding = banner_width - vim.fn.strdisplaywidth(line) - logo_indent
        return string.rep(" ", logo_indent) .. line .. string.rep(" ", padding)
      end

      dashboard.section.header.val = {
        banner_rule("╭", "N E O V I M  //  C Y B E R  W O R K S H O P", "╮"),
        banner_text(logo_lines[1]),
        banner_text(logo_lines[2]),
        banner_text(logo_lines[3]),
        banner_text(logo_lines[4]),
        banner_text(logo_lines[5]),
        banner_text(logo_lines[6]),
        banner_rule("╰", "C O D E  ·  B U I L D  ·  R E P E A T", "╯"),
      }

      dashboard.section.header.opts.hl = {
        { { "DashboardFrameAccent", 0, -1 } },
        { { "DashboardLogo1", 0, -1 } },
        { { "DashboardLogo2", 0, -1 } },
        { { "DashboardLogo3", 0, -1 } },
        { { "DashboardLogo4", 0, -1 } },
        { { "DashboardLogo5", 0, -1 } },
        { { "DashboardFrameAccent", 0, -1 } },
        { { "DashboardFrameAccent", 0, -1 } },
      }

      local root = require("utils.root").project_root(vim.uv.cwd())
      local welcome = {
        type = "text",
        val = string.format("Welcome back, %s! Today is %s", vim.env.USER or "user", os.date("%A, %d %B %Y")),
        opts = { position = "center", hl = "DashboardTitle" },
      }

      local working_directory = {
        type = "text",
        val = "You're working in " .. vim.fn.fnamemodify(root, ":~"),
        opts = { position = "center", hl = "DashboardPath" },
      }

      local plugins = {
        type = "text",
        val = plugin_summary(),
        opts = { position = "center", hl = "DashboardFooter" },
      }

      dashboard.section.buttons.val = {
        button("e", "", "New file", "<cmd>ene<cr>", "DashboardIconGreen"),
        button("f", "", "Find file", function()
          Snacks.picker.files({ layout = { preset = "telescope" }, cwd = vim.uv.cwd() })
        end, "DashboardIconBlue"),
        button("p", "", "Projects", function()
          Snacks.picker.projects({ layout = { preset = "select" } })
        end, "DashboardIconPeach"),
        button("s", "󰁯", "Restore session", function()
          require("persistence").load()
        end, "DashboardIconMauve"),
        button("m", "󰈸", "LeetCode", "<cmd>Leet<cr>", "DashboardIconRed"),
        button("c", "", "Open config", "<cmd>Oil ~/.config/nvim<cr>", "DashboardIconBlue"),
        button("l", "󰒲", "Lazy", "<cmd>Lazy<cr>", "DashboardIconMauve"),
        button("q", "", "Quit", "<cmd>qa<cr>", "DashboardIconRed"),
      }
      dashboard.section.buttons.opts.spacing = 1

      dashboard.config.layout = {
        { type = "padding", val = 4 },
        dashboard.section.header,
        { type = "padding", val = 4 },
        welcome,
        { type = "padding", val = 1 },
        working_directory,
        { type = "padding", val = 3 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        plugins,
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "VeryLazy",
        callback = function()
          plugins.val = plugin_summary()
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
      animate = { enabled = false },
      bottom = {
        {
          ft = "snacks_terminal",
          filter = function(buf)
            return not terminal_utils.snacks_terminal_cmd_contains(buf, "opencode attach")
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
            return terminal_utils.snacks_terminal_cmd_contains(buf, "opencode attach")
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
