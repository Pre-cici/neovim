return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPre',
    main = 'rainbow-delimiters.setup',
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
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    config = function()
      require('nvim-highlight-colors').setup {}
    end,
  },
  {
    'tummetott/reticle.nvim',
    event = 'BufReadPre',
    opts = {
      always_highlight_number = true,
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      cmdline = { enabled = false },
      messages = { enabled = false },
      popupmenu = { enabled = true },

      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      notify = {
        enabled = true,
        view = 'notify',
      },
    },

    keys = {
      { '<leader>n', '', desc = 'notice' },

      {
        '<leader>nn',
        function()
          require('noice').cmd 'pick'
        end,
        desc = 'Notification Search',
      },
      {
        '<leader>nl',
        function()
          require('noice').cmd 'last'
        end,
        desc = 'Noice Last Message',
      },
      {
        '<leader>nh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Noice History',
      },
      {
        '<leader>na',
        function()
          require('noice').cmd 'all'
        end,
        desc = 'Noice All',
      },
      {
        '<leader>nd',
        function()
          require('noice').cmd 'dismiss'
        end,
        desc = 'Dismiss All',
      },
    },

    config = function(_, opts)
      if vim.o.filetype == 'lazy' then
        vim.cmd [[messages clear]]
      end
      require('noice').setup(opts)
    end,
  },

  -- {
  --   'gelguy/wilder.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     local wilder = require 'wilder'
  --     wilder.setup { modes = { ':', '/', '?' } }
  --
  --     wilder.set_option(
  --       'renderer',
  --       wilder.popupmenu_renderer {
  --         -- highlighter applies highlighting to the candidates
  --         highlighter = wilder.basic_highlighter(),
  --       }
  --     )
  --     wilder.set_option(
  --       'renderer',
  --       wilder.renderer_mux {
  --         [':'] = wilder.popupmenu_renderer {
  --           highlighter = wilder.basic_highlighter(),
  --         },
  --         ['/'] = wilder.wildmenu_renderer {
  --           highlighter = wilder.basic_highlighter(),
  --         },
  --       }
  --     )
  --     wilder.set_option(
  --       'renderer',
  --       wilder.popupmenu_renderer {
  --         pumblend = 0,
  --       }
  --     )
  --     wilder.set_option(
  --       'renderer',
  --       wilder.popupmenu_renderer {
  --         highlighter = wilder.basic_highlighter(),
  --         left = { ' ', wilder.popupmenu_devicons() },
  --         right = { ' ', wilder.popupmenu_scrollbar() },
  --       }
  --     )
  --   end,
  -- },
}
