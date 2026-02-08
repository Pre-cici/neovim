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
        '<leader>mp',
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
    'tadmccorkle/markdown.nvim',
    ft = 'markdown', -- or 'event = "VeryLazy"'
    opts = {
      on_attach = function(bufnr)
        local wk = require 'which-key'
        wk.add { { '<leader>m', group = 'markdown' } }

        local map = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        -- 1) 更“编辑器化”的粗体/斜体（Visual 下像常见编辑器：Ctrl-b / Ctrl-i）
        local function toggle_visual(style_key)
          return "<Esc>gv<Cmd>lua require'markdown.inline'.toggle_emphasis_visual'" .. style_key .. "'<CR>"
        end
        map('x', '<C-b>', toggle_visual 'b', opts) -- bold
        map('x', '<C-i>', toggle_visual 'i', opts) -- italic

        -- Strikethrough (~~ ~~)
        map('x', '<C-s>', toggle_visual 's', opts) -- visual: toggle strikethrough

        map('x', '<C-c>', toggle_visual 'c', opts) -- visual: toggle strikethrough

        -- 3) 列表：插入上下项 / 切 task / 重算编号
        map({ 'n', 'i' }, '<M-o>', '<Cmd>MDListItemBelow<CR>', opts)
        map({ 'n', 'i' }, '<M-O>', '<Cmd>MDListItemAbove<CR>', opts)

        map('n', '<M-c>', '<Cmd>MDTaskToggle<CR>', opts)
        map('x', '<M-c>', ':MDTaskToggle<CR>', opts)

        map('n', '<leader>mc', '<Cmd>MDTaskToggle<CR>', opts)
        map('x', '<leader>mc', ':MDTaskToggle<CR>', opts)

        map('n', '<leader>mr', '<Cmd>MDResetListNumbering<CR>', opts)
        map('x', '<leader>mr', ':MDResetListNumbering<CR>', opts)
      end,
    },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'VeryLazy',
    opts = {
      render_modes = { 'n', 'c', 't', 'i', 'v' },

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
      checkbox = {
        unchecked = { icon = '󰄱', highlight = 'RenderMarkdownCodeFallback' },
        checked = { icon = '󰄵', highlight = 'RenderMarkdownUnchecked', scope_highlight = 'RenderMarkdownUnchecked' },
        custom = {
          todo = { raw = '[>]', rendered = '󰦖', highlight = 'RenderMarkdownInfo' },
          canceled = { raw = '[-]', rendered = '󰅚', highlight = 'RenderMarkdownUnchecked', scope_highlight = '@text.strike' },
          important = { raw = '[!]', rendered = '󰀪', highlight = 'RenderMarkdownWarn', scope_highlight = 'RenderMarkdownWarn' },
          favorite = { raw = '[~]', rendered = '󰌶', highlight = 'RenderMarkdownMath', scope_highlight = 'RenderMarkdownMath' },
        },
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo', category = 'github' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess', category = 'github' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint', category = 'github' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError', category = 'github' },
        -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
        abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        summary = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        tldr = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        info = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        hint = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        check = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        done = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        help = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        faq = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError', category = 'obsidian' },
        fail = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError', category = 'obsidian' },
        missing = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError', category = 'obsidian' },
        danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError', category = 'obsidian' },
        error = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError', category = 'obsidian' },
        bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError', category = 'obsidian' },
        example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint', category = 'obsidian' },
        quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
        cite = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
      },
      link = {
        custom = {
          heading = { pattern = '^#', icon = ' ' },
          note = { pattern = '%.md$', icon = ' ' },
        },
      },

      completions = {
        blink = { enabled = true },
        -- lsp = { enabled = true },
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      -- vim.cmd 'hi SpellBad gui=none guisp=none'

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
    'HakonHarnes/img-clip.nvim',
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    keys = {
      -- suggested keymap
      { '<leader>p', '<cmd>PasteImage<cr>', ft = 'markdown', desc = 'Paste image from system clipboard' },
    },
  },
  {
    'bngarren/checkmate.nvim',
    ft = 'markdown', -- Lazy loads for Markdown files matching patterns in 'files'
    opts = {
      style = false,
    },
  },
}
