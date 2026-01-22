return {
  {
    'folke/snacks.nvim',
    opts = {
      scope = { enabled = true },
      scroll = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
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
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = '󰙏', key = 'l', desc = 'LeetCode', action = ':Leet' },
            {
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
          -- Used by the `header` section
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
        -- item field formatters
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
}
