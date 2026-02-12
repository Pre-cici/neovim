return {
  { -- Treesitter: highlight / indent / folds / incremental selection
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "master",
    opts = {
      -- stylua: ignore
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown',
        'markdown_inline', 'query', 'vim', 'vimdoc', 'python',
        'json', 'yaml', "ninja", "rst"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = {
        enable = true,
        disable = { "ruby" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- vim.opt.foldmethod = "expr"
      -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      local function set_ctx_hl()
        -- 1) Disable bottom underline/border highlights
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", {})
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {})

        -- 2) Set background for context (pick one)
        -- Option A: explicit color
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1f2132" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#1f2132" })

        -- Option B: link to an existing highlight group (recommended if you want theme-consistent bg)
        -- Example: use NormalFloat background
        -- local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
        -- if nf and nf.bg then
        --   vim.api.nvim_set_hl(0, "TreesitterContext", { bg = nf.bg })
        --   vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = nf.bg })
        -- end
      end


      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_ctx_hl })
      set_ctx_hl()

      -- Optional: toggle
      vim.keymap.set("n", "<leader>tC", function()
        require("treesitter-context").toggle()
      end, { desc = "Toggle Treesitter Context" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["ak"] = { query = "@block.outer", desc = "around block" },
                ["ik"] = { query = "@block.inner", desc = "inside block" },
                ["ac"] = { query = "@class.outer", desc = "around class" },
                ["ic"] = { query = "@class.inner", desc = "inside class" },
                ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
                ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
                ["af"] = { query = "@function.outer", desc = "around function " },
                ["if"] = { query = "@function.inner", desc = "inside function " },
                ["al"] = { query = "@loop.outer", desc = "around loop" },
                ["il"] = { query = "@loop.inner", desc = "inside loop" },
                ["aa"] = { query = "@parameter.outer", desc = "around argument" },
                ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]k"] = { query = "@block.outer", desc = "Next block start" },
                ["]f"] = { query = "@function.outer", desc = "Next function start" },
                ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
              },
              goto_next_end = {
                ["]K"] = { query = "@block.outer", desc = "Next block end" },
                ["]F"] = { query = "@function.outer", desc = "Next function end" },
                ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
              },
              goto_previous_start = {
                ["[k"] = { query = "@block.outer", desc = "Previous block start" },
                ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
              },
              goto_previous_end = {
                ["[K"] = { query = "@block.outer", desc = "Previous block end" },
                ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
              },
            },
            swap = {
              enable = true,
              swap_next = {
                [">K"] = { query = "@block.outer", desc = "Swap next block" },
                [">F"] = { query = "@function.outer", desc = "Swap next function" },
                [">A"] = { query = "@parameter.inner", desc = "Swap next parameter" },
              },
              swap_previous = {
                ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
                ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
                ["<A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
              },
            },
          },
        })
      end

      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }

      local function has_textobjects_query(ft)
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return false
        end
        local okq, q = pcall(vim.treesitter.query.get, lang, "textobjects")
        return okq and q ~= nil
      end

      local function make_desc(key, query)
        local desc = query:gsub("@", ""):gsub("%..*", "")
        desc = desc:sub(1, 1):upper() .. desc:sub(2)
        desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
        desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
        return desc
      end

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not has_textobjects_query(ft) then
          return
        end

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            if vim.wo[vim.fn.bufwinid(buf)].diff and key:find("[cC]") then
              goto continue
            end

            vim.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = make_desc(key, query),
              silent = true,
            })

            ::continue::
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_textobjects_move", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })

      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) then
          attach(b)
        end
      end
    end,
  },
}
