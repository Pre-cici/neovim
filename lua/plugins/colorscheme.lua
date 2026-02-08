local colorscheme = 'catppuccin'
local schemes = {
  catppuccin = {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'macchiato', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
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
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
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
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
          },
          inlay_hints = {
            background = false,
          },
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            Pmenu = { bg = colors.none },
            BlinkCmpMenuBorder = { bg = colors.none },
            DropBarMenuHoverIcon = { bg = colors.none, fg = colors.flamingo, reverse = false },
            LazyNormal = { bg = colors.mantle, fg = colors.text },
            RenderMarkdownCode = { bg = colors.none },
          }
        end,
        default_integrations = true,
        auto_integrations = true,
        integrations = {},
      }
      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  tokyonight = {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        ---@diagnostic disable-next-line: missing-fields
        style = 'night', -- "storm", "moon", "night", "day"
      }
      vim.cmd.colorscheme 'tokyonight'
    end,
  },

  everforest = {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme 'everforest'
    end,
  },

  ['gruvbox-material'] = {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  kanagawa = {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        background = {
          dark = 'wave', -- "wave", "dragon", "lotus"
          light = 'lotus',
        },
      }
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
}

return { schemes[colorscheme] }
