local colorscheme = "rose-pine"
local schemes = {
  ["rose-pine"] = {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        dim_inactive_windows = false,
        extend_background_behind_borders = false,
        enable = {
          terminal = false,
          legacy_highlights = true,
          migrations = true,
        },
        styles = {
          bold = true,
          italic = false,
          transparency = vim.g.transparent,
        },
        highlight_groups = {
          EndOfBuffer = { fg = "base" },
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          NormalSB = { bg = "none" },
          Pmenu = { bg = "none" },
          BlinkCmpMenuBorder = { bg = "none" },
          NotifyBackground = { bg = "base" },
          DropBarMenuHoverIcon = { bg = "none", fg = "rose", reverse = false },
          LazyNormal = { bg = "surface", fg = "text" },
          StatusLineTerm = { link = "StatusLine" },
          StatusLineTermNC = { link = "StatusLineNC" },
          RenderMarkdownCode = { bg = "none" },
          Comment = { italic = true },
          Conditional = { italic = true },
          DiagnosticVirtualTextError = { italic = true },
          DiagnosticVirtualTextHint = { italic = true },
          DiagnosticVirtualTextInfo = { italic = true },
          DiagnosticVirtualTextOk = { italic = true },
          DiagnosticVirtualTextWarn = { italic = true },
          LspInlayHint = { bg = "none" },
          ["@markup.strong"] = { fg = "love", bold = true },
          ["@markup.italic"] = { fg = "love", italic = true },
          ["@markup.strikethrough"] = { fg = "muted", strikethrough = true },
          ["@markup.math"] = { fg = "foam" },
          ["@markup.quote"] = { fg = "rose" },
          ["@markup.environment"] = { fg = "rose" },
          ["@markup.environment.name"] = { fg = "foam" },
          ["@markup.link"] = { fg = "iris" },
          ["@markup.link.markdown_inline"] = { fg = "iris" },
          ["@markup.link.label"] = { fg = "iris" },
          ["@markup.link.label.markdown_inline"] = { fg = "iris" },
          ["@markup.link.url"] = { fg = "foam", italic = true, underline = true },
          ["@markup.raw"] = { fg = "foam" },
          ["@markup.raw.markdown_inline"] = { fg = "foam" },
          ["@markup.list"] = { fg = "pine" },
          ["@markup.list.checked"] = { fg = "foam" },
          ["@markup.list.unchecked"] = { fg = "muted" },
        },
      })
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },

  catppuccin = {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = vim.g.transparent, -- disables setting the background color.
        float = {
          transparent = vim.g.transparent, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = false,
          },
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            NormalFloat = { bg = colors.none },
            FloatBorder = { bg = colors.none },
            NormalSB = { bg = colors.none },
            Pmenu = { bg = colors.none },
            BlinkCmpMenuBorder = { bg = colors.none },
            DropBarMenuHoverIcon = { bg = colors.none, fg = colors.flamingo, reverse = false },
            LazyNormal = { bg = colors.mantle, fg = colors.text },
            RenderMarkdownCode = { bg = colors.none },
            ["@markup.italic"] = { fg = colors.flamingo, italic = true },
          }
        end,
        default_integrations = true,
        auto_integrations = true,
        integrations = {},
      })
      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  tokyonight = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        ---@diagnostic disable-next-line: missing-fields
        style = "night", -- "storm", "moon", "night", "day"
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  everforest = {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme("everforest")
    end,
  },

  ["gruvbox-material"] = {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  kanagawa = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        background = {
          dark = "wave", -- "wave", "dragon", "lotus"
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}

return { schemes[colorscheme] }
