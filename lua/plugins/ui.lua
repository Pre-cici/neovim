return {
  {
    'folke/snacks.nvim',
    opts = {
      indent = {
        indent = {
          enabled = true,
          char = '',
          hl = 'SnacksIndent', ---@type string|string[] hl groups for indent guides
        },
        animate = {
          enabled = vim.fn.has 'nvim-0.10' == 0,
        },
        scope = {
          enabled = true,
          char = '│',
          underline = false,
          only_current = true,
          hl = 'SnacksIndentScope', ---@type string|string[] hl group for scopes
        },
        chunk = {
          enabled = true,
          only_current = true,
          hl = 'SnacksIndentChunk', ---@type string|string[] hl group for chunk scopes
          char = {
            corner_top = '╭',
            corner_bottom = '╰',
            horizontal = '─',
            vertical = '│',
            arrow = '─',
          },
        },
      },
      statuscolumn = {
        enabled = true,
        folds = {
          open = true, -- show open fold icons
          git_hl = true, -- use Git Signs hl for fold icons
        },
      },

      dashboard = {
        preset = {
          header = [[         
                             █████                                          
                            ▒▒███                                           
 ████████   ██████   █████  ███████   ████████   ██████  ████████    ██████ 
▒▒███▒▒███ ███▒▒███ ███▒▒  ▒▒▒███▒   ▒▒███▒▒███ ███▒▒███▒▒███▒▒███  ███▒▒███
 ▒███ ▒███▒███ ▒███▒▒█████   ▒███     ▒███ ▒███▒███ ▒███ ▒███ ▒███ ▒███████ 
 ▒███ ▒███▒███ ▒███ ▒▒▒▒███  ▒███ ███ ▒███ ▒███▒███ ▒███ ▒███ ▒███ ▒███▒▒▒  
 ▒███████ ▒▒██████  ██████   ▒▒█████  ▒███████ ▒▒██████  ████ █████▒▒██████ 
 ▒███▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒▒▒     ▒▒▒▒▒   ▒███▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒  ▒▒▒▒▒▒  
 ▒███                                 ▒███                                  
 █████                                █████                                 
▒▒▒▒▒                                ▒▒▒▒▒                                  ]],
        },
        sections = {
          {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
      },
    },
  },
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
      { '<leader>n', '', desc = 'notice' },
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
      if vim.o.filetype == 'lazy' then
        vim.cmd [[messages clear]]
      end
      require('noice').setup(opts)
    end,
  },
}
