return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      {
        '<leader>cp',
        ft = 'markdown',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
      },
    },
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'VeryLazy',
    opts = {
      code = {
        sign = false,
        disable_background = true,
        style = 'language',
      },
      heading = {
        sign = false,
        width = 'block',
        render_modes = true, -- keep rendering while inserting
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      vim.cmd 'hi SpellBad gui=none guisp=none'
      Snacks.toggle({
        name = 'Render Markdown',
        get = function()
          return require('render-markdown.state').enabled
        end,
        set = function(enabled)
          local m = require 'render-markdown'
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map '<leader>tm'
    end,
  },
  {
    'bngarren/checkmate.nvim',
    ft = 'markdown', -- Lazy loads for Markdown files matching patterns in 'files'
    opts = {
      -- files = { "*.md" }, -- any .md file (instead of defaults)
    },
  },
}
