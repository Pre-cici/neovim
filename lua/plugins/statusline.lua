return {
  {
    'rebelot/heirline.nvim',
    event = 'UIEnter',
    dependencies = { 'Zeioth/heirline-components.nvim' },
    opts = function()
      local lib = require 'heirline-components.all'
      local conditions = require 'heirline.conditions'
      local utils = require 'heirline.utils'

      local LspClients = {
        hl = { fg = 'green', bold = true },
        condition = conditions.lsp_attached,
        update = { 'LspAttach', 'LspDetach', 'BufEnter', 'BufWritePost' },
        init = function(self)
          local names = {}
          for _, c in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
            names[#names + 1] = c.name
          end
          table.sort(names)
          self._txt = table.concat(names, ', ')
        end,
        provider = function(self)
          if not self._txt or self._txt == '' then
            return ''
          end
          return '  ' .. self._txt
        end,
        on_click = {
          name = 'heirline_lsp_clients',
          callback = function()
            vim.schedule(function()
              if vim.fn.exists ':LspInfo' == 2 then
                vim.cmd 'LspInfo'
              else
                vim.cmd 'checkhealth vim.lsp'
              end
            end)
          end,
        },
      }

      local WorkDir = {
        condition = function()
          return not conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'terminal', 'quickfix' },
            filetype = {
              'help',
              'lazy',
              'mason',
              'TelescopePrompt',
              'TelescopeResults',
              'neo%-tree',
              'NvimTree',
              'qf',
              'checkhealth',
            },
            -- bufname 也可以加一些模式（可选）
            -- bufname = { "DAP REPL", "Trouble" },
          }, 0)
        end,
        {
          provider = function()
            return ' '
          end,
          hl = function()
            if vim.fn.haslocaldir(0) == 1 then
              return { fg = 'cyan', bold = true }
            end
            return { fg = 'blue', bold = false }
          end,
        },

        {
          provider = function()
            local cwd = vim.fn.getcwd(0)
            cwd = vim.fn.fnamemodify(cwd, ':~')
            if not conditions.width_percent_below(#cwd, 0.25) then
              cwd = vim.fn.pathshorten(cwd)
            end
            return cwd .. " "
          end,
          hl = { fg = 'blue', bold = true },
        },
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == 'help'
        end,
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          return vim.fn.fnamemodify(filename, ':t')
        end,
        hl = { fg = 'blue' },
      }

      return {
        opts = {
          disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
            local is_disabled = not require('heirline-components.buffer').is_valid(args.buf)
              or lib.condition.buffer_matches({
                buftype = { 'terminal', 'prompt', 'nofile', 'help', 'quickfix' },
                filetype = { 'NvimTree', 'neo%-tree', 'dashboard', 'Outline', 'aerial' },
              }, args.buf)
            return is_disabled
          end,
          colors = {
            none = 'NONE',

            fg = '#CAD3F5', -- foreground
            bg = 'NONE', -- background
            dark_bg = '#5B6078', -- selectionBackground

            blue = '#8AADF4',
            green = '#A6DA95',
            red = '#ED8796',
            yellow = '#EED49F',
            purple = '#F5BDE6',
            cyan = '#8BD5CA',
            white = '#B8C0E0',
            black = '#494D64',
            orange = '#F5A97F',

            grey = '#5B6078', -- brightBlack / selectionBackground
            bright_grey = '#A5ADCB', -- brightWhite（更亮的灰蓝）
            dark_grey = '#494D64', -- black（更暗的灰）

            bright_blue = '#8AADF4',
            bright_green = '#A6DA95',
            bright_red = '#ED8796',
            bright_yellow = '#EED49F',
            bright_purple = '#F5BDE6',
            bright_cyan = '#8BD5CA',
            bright_white = '#A5ADCB',
            bright_black = '#5B6078',
          },
        },

        -- tabline = { -- UI upper bar
        --   lib.component.tabline_conditional_padding(),
        --   lib.component.tabline_buffers(),
        --   lib.component.fill { hl = { bg = 'tabline_bg' } },
        --   lib.component.tabline_tabpages(),
        -- },
        -- winbar = { -- UI breadcrumbs bar
        --   init = function(self)
        --     self.bufnr = vim.api.nvim_get_current_buf()
        --   end,
        --   fallthrough = false,
        --   -- Winbar for terminal, neotree, and aerial.
        --   {
        --     condition = function()
        --       return not lib.condition.is_active()
        --     end,
        --     {
        --       lib.component.neotree(),
        --       lib.component.compiler_play(),
        --       lib.component.fill(),
        --       lib.component.compiler_build_type(),
        --       lib.component.compiler_redo(),
        --       lib.component.aerial(),
        --     },
        --   },
        --   -- Regular winbar
        --   {
        --     lib.component.neotree(),
        --     lib.component.compiler_play(),
        --     lib.component.fill(),
        --     lib.component.breadcrumbs(),
        --     lib.component.fill(),
        --     lib.component.compiler_redo(),
        --     lib.component.aerial(),
        --   },
        -- },

        statusline = { -- UI statusbar
          hl = { fg = 'fg', bg = 'bg' },
          lib.component.mode(),
          lib.component.git_branch(),
          WorkDir,
          lib.component.file_info(),
          HelpFileName,
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          -- lib.component.lsp(),
          LspClients,
          -- lib.component.compiler_state(),
          lib.component.virtual_env(),
          lib.component.nav { percentage = false },
          lib.component.mode { surround = { separator = 'right' } },
        },
      }
    end,
    config = function(_, opts)
      local heirline = require 'heirline'
      local heirline_components = require 'heirline-components.all'
      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },

  {
    'b0o/incline.nvim',
    event = 'BufReadPre',
    priority = 1200,
    config = function()
      require('incline').setup {
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if vim.bo[props.buf].modified then
            filename = '[+] ' .. filename
          end

          local icon, color = require('nvim-web-devicons').get_icon_color(filename)
          return { { icon, guifg = color }, { ' ' }, { filename } }
        end,
      }
    end,
  },
}
