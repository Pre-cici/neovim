return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      on_attach = function(bufnr)
        local wk = require("which-key")
        wk.add({ { "<leader>m", group = "markdown" } })

        local map = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        -- 1) 更“编辑器化”的粗体/斜体（Visual 下像常见编辑器：Ctrl-b / Ctrl-i）
        local function toggle_visual(style_key)
          return "<Esc>gv<Cmd>lua require'markdown.inline'.toggle_emphasis_visual'" .. style_key .. "'<CR>"
        end

        map("x", "<C-b>", toggle_visual("b"), opts) -- bold
        map("x", "<C-i>", toggle_visual("i"), opts) -- italic

        -- Strikethrough (~~ ~~)
        map("x", "<C-s>", toggle_visual("s"), opts) -- visual: toggle strikethrough

        -- Code(` `)
        map("x", "<C-c>", toggle_visual("c"), opts) -- visual: toggle code

        -- 3) 列表：插入上下项 / 切 task / 重算编号
        map({ "n", "i" }, "<M-o>", "<Cmd>MDListItemBelow<CR>", opts)
        map({ "n", "i" }, "<M-O>", "<Cmd>MDListItemAbove<CR>", opts)

        map("n", "<leader>mr", "<Cmd>MDResetListNumbering<CR>", opts)
        map("x", "<leader>mr", ":MDResetListNumbering<CR>", opts)
      end,
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    opts = {
      code = {
        sign = false,
        disable_background = true,
        width = "block",
        style = "language",
      },
      heading = {
        sign = false,
        width = "block",
        render_modes = true, -- keep rendering while inserting
      },
      link = {
        custom = {
          heading = { pattern = "^#", icon = " " },
          note = { pattern = "%.md$", icon = " " },
        },
      },
      checkbox = {
        unchecked = { icon = "󰄱", highlight = "RenderMarkdownCodeFallback" },
        checked = { icon = "󰄵", highlight = "RenderMarkdownUnchecked", scope_highlight = "RenderMarkdownUnchecked" },
        custom = {
          todo = { raw = "[>]", rendered = "󰦖", highlight = "RenderMarkdownInfo" },
          canceled = {
            raw = "[-]",
            rendered = "󰅚",
            highlight = "RenderMarkdownUnchecked",
            scope_highlight = "@text.strike",
          },
          important = {
            raw = "[!]",
            rendered = "󰀪",
            highlight = "RenderMarkdownWarn",
            scope_highlight = "RenderMarkdownWarn",
          },
          favorite = {
            raw = "[~]",
            rendered = "󰌶",
            highlight = "RenderMarkdownMath",
            scope_highlight = "RenderMarkdownMath",
          },
        },
      },

      completions = {
        blink = { enabled = true },
        -- lsp = { enabled = true },
      },
      quote = { repeat_linebreak = true },
      win_options = {
        showbreak = {
          default = "",
          rendered = "  ",
        },
        breakindent = {
          default = false,
          rendered = true,
        },
        breakindentopt = {
          default = "",
          rendered = "",
        },
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- vim.cmd 'hi SpellBad gui=none guisp=none'

      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>tm")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "bngarren/checkmate.nvim",
    ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
    opts = {
      files = { "*.md" },

      todo_states = {
        -- Built-in states (cannot change markdown or type)
        unchecked = { marker = "󰄱 " },
        checked = { marker = "󰄵 " },

        -- Custom states
        in_progress = {
          marker = "◐",
          markdown = ".", -- Saved as `- [.]`
          type = "incomplete", -- Counts as "not done"
          order = 50,
        },

        on_hold = {
          marker = "⏸ ",
          markdown = "/", -- Saved as `- [/]`
          type = "inactive", -- Ignored in counts
          order = 100,
        },
      },
      style = {}, -- override defaults

      keys = { -- TODO: Move to the keymappings file.
        ["<leader>mc"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "Markdown - Toggle check",
          modes = { "n", "v" },
        },
      },
    },
  },
}
