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
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      image = {
        formats = {
          'png',
          'jpg',
          'jpeg',
          'gif',
          'bmp',
          'webp',
          'tiff',
          'heic',
          'avif',
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
          'pdf',
          'icns',
        },
        force = true, -- try displaying the image, even if the terminal does not support it
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = false,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 80,
          max_height = 40,
          -- Set to `true`, to conceal the image text when rendering inline.
          -- (experimental)
          ---@param lang string tree-sitter language
          ---@param type snacks.image.Type image type
          conceal = function(lang, type)
            -- only conceal math expressions
            return type == 'math'
          end,
        },
        img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments' },
        -- window options applied to windows displaying image buffers
        -- an image buffer is a buffer with `filetype=image`
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = 'no',
          foldcolumn = '0',
          list = false,
          spell = false,
          statuscolumn = '',
        },
        cache = vim.fn.stdpath 'cache' .. '/snacks/image',
        debug = {
          request = false,
          convert = false,
          placement = false,
        },
        env = {},
        -- icons used to show where an inline image is located that is
        -- rendered below the text.
        icons = {
          math = '󰪚 ',
          chart = '󰄧 ',
          image = ' ',
        },
        ---@class snacks.image.convert.Config
        convert = {
          notify = true, -- show a notification on error
          ---@type snacks.image.args
          mermaid = function()
            local theme = vim.o.background == 'light' and 'neutral' or 'dark'
            return { '-i', '{src}', '-o', '{file}', '-b', 'transparent', '-t', theme, '-s', '{scale}' }
          end,
          ---@type table<string,snacks.image.args>
          magick = {
            default = { '{src}[0]', '-scale', '1920x1080>' }, -- default for raster images
            vector = { '-density', 192, '{src}[{page}]' }, -- used by vector images like svg
            math = { '-density', 192, '{src}[{page}]', '-trim' },
            pdf = { '-density', 192, '{src}[{page}]', '-background', 'white', '-alpha', 'remove', '-trim' },
          },
        },
        math = {
          enabled = false, -- enable math expression rendering
          -- in the templates below, `${header}` comes from any section in your document,
          -- between a start/end header comment. Comment syntax is language-specific.
          -- * start comment: `// snacks: header start`
          -- * end comment:   `// snacks: header end`
          typst = {
            tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
          },
          latex = {
            font_size = 'Large', -- see https://www.sascha-frank.com/latex-font-size.html
            -- for latex documents, the doc packages are included automatically,
            -- but you can add more packages here. Useful for markdown documents.
            packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
            tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
          },
        },
      },
    },
  },
  -- {
  --   '3rd/image.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('image').setup {
  --       backend = 'sixel', -- or "ueberzug" or "sixel"
  --       processor = 'magick_cli', -- or "magick_rock"
  --       integrations = {
  --         markdown = {
  --           enabled = true,
  --           clear_in_insert_mode = false,
  --           download_remote_images = true,
  --           only_render_image_at_cursor = false,
  --           only_render_image_at_cursor_mode = 'popup', -- or "inline"
  --           floating_windows = false, -- if true, images will be rendered in floating markdown windows
  --           filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
  --         },
  --         neorg = {
  --           enabled = true,
  --           filetypes = { 'norg' },
  --         },
  --         typst = {
  --           enabled = true,
  --           filetypes = { 'typst' },
  --         },
  --         html = {
  --           enabled = false,
  --         },
  --         css = {
  --           enabled = false,
  --         },
  --       },
  --       max_width = nil,
  --       max_height = nil,
  --       max_width_window_percentage = nil,
  --       max_height_window_percentage = 50,
  --       scale_factor = 1.0,
  --       window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  --       window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
  --       editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  --       tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  --       hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
  --     }
  --   end,
  -- },
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    -- keymaps = {
    --   ['<leader>p'] = function()
    --     local oil = require 'oil'
    --     local filename = oil.get_cursor_entry().name
    --     local dir = oil.get_current_dir()
    --     oil.close()
    --
    --     local img_clip = require 'img-clip'
    --     img_clip.paste_image({}, dir .. filename)
    --   end,
    -- },
    keys = {
      -- suggested keymap
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
}
