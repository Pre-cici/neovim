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
  -- {
  --   "rcarriga/nvim-notify",
  --   opts = function()
  --     local fps
  --     if is_android then fps = 30 else fps = 244 end
  --     return {
  --       timeout = 2500,
  --       fps = fps,
  --       max_height = function() return math.floor(vim.o.lines * 0.75) end,
  --       max_width = function() return math.floor(vim.o.columns * 0.75) end,
  --       on_open = function(win)
  --         -- enable markdown support on notifications
  --         vim.api.nvim_win_set_config(win, { zindex = 175 })
  --         if not vim.g.notifications_enabled then
  --           vim.api.nvim_win_close(win, true)
  --         end
  --         if not package.loaded["nvim-treesitter"] then
  --           pcall(require, "nvim-treesitter")
  --         end
  --         vim.wo[win].conceallevel = 3
  --         local buf = vim.api.nvim_win_get_buf(win)
  --         if not pcall(vim.treesitter.start, buf, "markdown") then
  --           vim.bo[buf].syntax = "markdown"
  --         end
  --         vim.wo[win].spell = false
  --       end,
  --     }
  --   end,
  --   config = function(_, opts)
  --     local notify = require("notify")
  --     notify.setup(opts)
  --     vim.notify = notify
  --   end,
  -- },
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
        presets = { bottom_search = true }, -- The kind of popup used for /
        cmdline = {
          view = 'cmdline', -- The kind of popup used for :
          format = {
            cmdline = { conceal = enable_conceal },
            search_down = { conceal = enable_conceal },
            search_up = { conceal = enable_conceal },
            filter = { conceal = enable_conceal },
            lua = { conceal = enable_conceal },
            help = { conceal = enable_conceal },
            input = { conceal = enable_conceal },
          },
        },

        popupmenu = { enabled = true },
        -- Disable every other noice feature
        messages = { enabled = true },
        lsp = {
          hover = { enabled = false },
          signature = { enabled = false },
          progress = { enabled = false },
          message = { enabled = false },
          smart_move = { enabled = false },
        },
      }
    end,
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
  },
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   opts = {
  --     cmdline = { enabled = false },
  --     messages = { enabled = false },
  --     popupmenu = { enabled = true },
  --
  --     lsp = {
  --       progress = { enabled = false },
  --       hover = { enabled = false },
  --       signature = { enabled = false },
  --       message = { enabled = false },
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --         ['cmp.entry.get_documentation'] = true,
  --       },
  --     },
  --     notify = {
  --       enabled = true,
  --       view = 'notify',
  --     },
  --   },
  --
  --   keys = {
  --     { '<leader>n', '', desc = 'notice' },
  --
  --     {
  --       '<leader>nn',
  --       function()
  --         require('noice').cmd 'pick'
  --       end,
  --       desc = 'Notification Search',
  --     },
  --     {
  --       '<leader>nl',
  --       function()
  --         require('noice').cmd 'last'
  --       end,
  --       desc = 'Noice Last Message',
  --     },
  --     {
  --       '<leader>nh',
  --       function()
  --         require('noice').cmd 'history'
  --       end,
  --       desc = 'Noice History',
  --     },
  --     {
  --       '<leader>na',
  --       function()
  --         require('noice').cmd 'all'
  --       end,
  --       desc = 'Noice All',
  --     },
  --     {
  --       '<leader>nd',
  --       function()
  --         require('noice').cmd 'dismiss'
  --       end,
  --       desc = 'Dismiss All',
  --     },
  --   },
  --
  --   config = function(_, opts)
  --     if vim.o.filetype == 'lazy' then
  --       vim.cmd [[messages clear]]
  --     end
  --     require('noice').setup(opts)
  --   end,
  -- },
}
