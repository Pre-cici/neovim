return {
  {
    'rebelot/heirline.nvim',
    event = 'UIEnter',
    dependencies = { 'Zeioth/heirline-components.nvim' },
    opts = function()
      local lib = require 'heirline-components.all'
      local conditions = require 'heirline.conditions'
      local utils = require 'heirline.utils'

      local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        surround = {
          separator = 'right',
        },
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
          mode_names = { -- change the strings if you like it vvvvverbose!
            n = 'NORMAL',
            no = 'NORMAL (no)',
            nov = 'NORMAL (nov)',
            noV = 'NORMAL (noV)',
            ['noCTRL-V'] = 'NORMAL',

            niI = 'NORMAL i',
            niR = 'NORMAL r',
            niV = 'NORMAL v',

            nt = 'NTERMINAL',
            ntT = 'NTERMINAL (ntT)',

            v = 'VISUAL',
            vs = 'V-CHAR (Ctrl O)',
            V = 'V-LINE',
            Vs = 'V-LINE',
            [''] = 'V-BLOCK',

            i = 'INSERT',
            ic = 'INSERT',
            ix = 'INSERT',

            t = 'TERMINAL',

            R = 'RcPLACE',
            Rc = 'REPLACE (Rc)',
            Rx = 'REPLACEa (Rx)',
            Rv = 'V-REPLACE',
            Rvc = 'V-REPLACE (Rvc)',
            Rvx = 'V-REPLACE (Rvx)',

            s = 'SELECT',
            S = 'S-LINE',
            [''] = 'S-BLOCK',

            c = 'COMMAND',
            cv = 'COMMAND',
            ce = 'COMMAND',
            cr = 'COMMAND',

            r = 'PROMPT',
            rm = 'MORE',
            ['r?'] = 'CONFIRM',
            x = 'CONFIRM',

            ['!'] = 'SHELL',
          },

          mode_colors = {
            n = 'yellow',
            i = 'green',
            v = 'cyan',
            V = 'cyan',
            ['\22'] = 'cyan',
            c = 'orange',
            s = 'purple',
            S = 'purple',
            ['\19'] = 'purple',
            R = 'orange',
            r = 'orange',
            ['!'] = 'red',
            t = 'red',
          },
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long. Plus a nice Icon.
        provider = function(self)
          return ' %2(' .. self.mode_names[self.mode] .. ' ' .. '%)'
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
          'ModeChanged',
          pattern = '*:*',
          callback = vim.schedule_wrap(function()
            vim.cmd 'redrawstatus'
          end),
        },
      }

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
              return { fg = 'cyan', italic = true }
            end
            return { fg = 'blue', italic = false }
          end,
        },

        {
          provider = function()
            local cwd = vim.fn.getcwd(0)
            cwd = vim.fn.fnamemodify(cwd, ':~')
            if not conditions.width_percent_below(#cwd, 0.25) then
              cwd = vim.fn.pathshorten(cwd)
            end
            return cwd .. ' '
          end,
          hl = { fg = 'blue', italic = true },
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

      -- Heirline component: show active venv from venv-selector.nvim
      local function venv_selector_path()
        local ok, vs = pcall(require, 'venv-selector')
        if not ok then
          return nil
        end
        return vs.venv() -- absolute path or nil
      end

      local function venv_selector_name()
        local v = venv_selector_path()
        if not v or v == '' then
          return nil
        end
        -- Trim trailing slashes and take the last segment (works on Linux/Windows paths)
        v = v:gsub('[/\\]+$', '')
        return v:match '([^/\\]+)$' or v
      end

      local VenvComponent = {
        hl = { fg = 'yellow', bold = true },
        condition = function()
          return venv_selector_name() ~= nil
        end,
        provider = function()
          return '  ' .. ' ' .. venv_selector_name()
        end,
        on_click = {
          name = 'heirline_venv_selector',
          callback = function()
            local ok = pcall(require, 'venv-selector')
            if ok then
              vim.schedule(vim.cmd.VenvSelect)
            end
          end,
        },
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
          ViMode,
          -- lib.component.mode(),
          lib.component.git_branch(),
          WorkDir,
          lib.component.file_info(),
          HelpFileName,
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          LspClients,
          -- lib.component.compiler_state(),
          VenvComponent,
          lib.component.nav { percentage = false },
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
    event = { 'BufReadPre', "BufNewFile" },
    -- dependencies = {
    --   {
    --     'SmiteshP/nvim-navic',
    --     lazy = false,
    --     dependencies = 'neovim/nvim-lspconfig',
    --     opts = {
    --       lsp = {
    --         auto_attach = true,
    --         preference = nil,
    --       },
    --       highlight = false,
    --       separator = ' > ',
    --       depth_limit = 0,
    --       depth_limit_indicator = '..',
    --       safe_output = true,
    --       lazy_update_context = false,
    --       click = false,
    --       format_text = function(text)
    --         return text
    --       end,
    --     },
    --   },
    -- },
    config = function()
      require('incline').setup {
        window = {
          -- placement = {
          --   horizontal = 'left',
          --   vertical = 'top',
          -- },
          margin = { vertical = 1, horizontal = 1 },
        },

        render = function(props)
          local buf = props.buf
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')

          if filename == '' then
            filename = '[No Name]'
          end
          if vim.bo[buf].modified then
            filename = '[+] ' .. filename
          end

          local icon, color = require('nvim-web-devicons').get_icon_color(filename)
          -- local navic = require 'nvim-navic'

          local res = {
            { icon, guifg = color, gui = 'italic' },
            { ' ', gui = 'italic' },
            { filename, gui = 'italic' },
          }

          -- if props.focused and navic.is_available(buf) then
          --   for _, item in ipairs(navic.get_data(buf) or {}) do
          --     table.insert(res, { ' > ', group = 'NavicSeparator', gui = 'italic' })
          --     if item.icon and item.type then
          --       table.insert(res, { item.icon, group = 'NavicIcons' .. item.type, gui = 'italic' })
          --     end
          --     table.insert(res, { item.name or '', group = 'NavicText', gui = 'italic' })
          --   end
          -- end
          --
          -- table.insert(res, { ' ', gui = 'italic' })

          return res
        end,
        -- vim.api.nvim_set_hl(0, 'NavicText', { italic = true }),
        -- vim.api.nvim_set_hl(0, 'NavicSeparator', { italic = true }),
      }
    end,
  },
}
