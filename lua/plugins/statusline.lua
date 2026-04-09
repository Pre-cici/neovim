return {
  {
    'rebelot/heirline.nvim',
    event = 'UIEnter',
    dependencies = { 'Zeioth/heirline-components.nvim' },
    opts = function()
      local lib = require 'heirline-components.all'
      local conditions = require 'heirline.conditions'
      local statusline_utils = require 'utils.statusline'

      local ViMode = statusline_utils.vi_mode()
      local LspClients = statusline_utils.lsp_clients(conditions)
      local WorkDir = statusline_utils.work_dir(conditions)
      local HelpFileName = statusline_utils.help_file_name()
      local VenvComponent = statusline_utils.venv_component()

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
          colors = statusline_utils.colors,
        },

        statusline = { -- UI statusbar
          hl = { fg = 'fg', bg = 'bg' },
          ViMode,
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
    config = function()
      require('incline').setup {
        window = {
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
          local res = {
            { icon, guifg = color, gui = 'italic' },
            { ' ', gui = 'italic' },
            { filename, gui = 'italic' },
          }

          return res
        end,
      }
    end,
  },
}
