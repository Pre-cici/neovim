return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      ts.install({
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "python",
        "json",
        "yaml",
        "ninja",
        "rst",
        "latex",
      })

      local augroup = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(args)
          local ft = args.match
          if not ft or ft == "" then
            return
          end

          local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
          lang = (ok_lang and lang) or ft

          local ok_add = pcall(vim.treesitter.language.add, lang)
          if ok_add then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local ft = vim.bo[buf].filetype
          if ft ~= "" then
            local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
            lang = (ok_lang and lang) or ft

            local ok_add = pcall(vim.treesitter.language.add, lang)
            if ok_add then
              pcall(vim.treesitter.start, buf, lang)
            end
          end
        end
      end
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
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local selections = {
        ab = { "@block.outer", "Around block" },
        ib = { "@block.inner", "Inside block" },
        ac = { "@class.outer", "Around class" },
        ic = { "@class.inner", "Inside class" },
        af = { "@function.outer", "Around function" },
        ["if"] = { "@function.inner", "Inside function" },
      }

      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }

      local swaps = {
        swap_next = {
          [">K"] = { "@block.outer", "Swap next block" },
          [">F"] = { "@function.outer", "Swap next function" },
          [">A"] = { "@parameter.inner", "Swap next parameter" },
        },
        swap_previous = {
          ["<K"] = { "@block.outer", "Swap previous block" },
          ["<F"] = { "@function.outer", "Swap previous function" },
          ["<A"] = { "@parameter.inner", "Swap previous parameter" },
        },
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

        for key, spec in pairs(selections) do
          local query, desc = spec[1], spec[2]
          vim.keymap.set({ "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
          end, {
            buffer = buf,
            desc = desc,
            silent = true,
          })
        end

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local winid = vim.fn.bufwinid(buf)
            if winid ~= -1 and vim.wo[winid].diff and key:find("[cC]") then
              goto continue
            end

            local move_method, move_query = method, query
            vim.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[move_method](move_query, "textobjects")
            end, {
              buffer = buf,
              desc = make_desc(key, move_query),
              silent = true,
            })

            ::continue::
          end
        end

        for method, keymaps in pairs(swaps) do
          for key, spec in pairs(keymaps) do
            local swap_method, query, desc = method, spec[1], spec[2]
            vim.keymap.set("n", key, function()
              require("nvim-treesitter-textobjects.swap")[swap_method](query)
            end, {
              buffer = buf,
              desc = desc,
              silent = true,
            })
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
