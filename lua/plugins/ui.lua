return {
  {
    'folke/snacks.nvim',
    opts = {
      indent = {
        indent = { char = '' },
        animate = { enabled = false },
        scope = { char = '│', only_current = true },
        chunk = {
          enabled = true,
          only_current = true,
          char = {
            corner_top = '╭',
            corner_bottom = '╰',
            horizontal = '─',
            vertical = '│',
            arrow = '─',
          },
        },
      },
      statuscolumn = { folds = { open = true, git_hl = true } },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = function()
      local enable_conceal = false -- Hide command text if true
      return {
        cmdline = {
          view = 'cmdline', -- The kind of popup used for :
          format = {
            cmdline = { icon = '', conceal = enable_conceal },
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
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
              },
            },
            view = 'mini',
          },
        },

        messages = {
          enabled = true,
          view = 'mini',
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
    -- config = function(_, opts)
    --   -- HACK: noice shows messages from before it was enabled,
    --   -- but this is not ideal when Lazy is installing plugins,
    --   -- so clear the messages in this case.
    --   if vim.o.filetype == 'lazy' then
    --     vim.cmd [[messages clear]]
    --   end
    --   require('noice').setup(opts)
    -- end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPre',
  },

  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    config = function()
      require('nvim-highlight-colors').setup {}
    end,
  },

  {
    'lukas-reineke/virt-column.nvim',
    event = 'BufReadPre',
    opts = {
      char = '⋮', -- "|", "", "┇", "∶", "∷", "║", "", "󰮾",
      virtcolumn = '120',
    },
  },

  {
    'tummetott/reticle.nvim',
    event = 'BufReadPre',
    opts = {
      always_highlight_number = true,
      ignore = {
        cursorline = {
          'Trouble',
          'snacks_picker_list',
          'snacks_picker_input',
        },
        cursorcolumn = {},
      },
    },
  },
}
