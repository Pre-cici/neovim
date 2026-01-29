return {
  { -- Treesitter: highlight / indent / folds / incremental selection
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'master',
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
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- vim.opt.foldmethod = "expr"
      -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },

    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if ok then
        configs.setup {
          textobjects = {
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {},
              goto_next_end = {},
              goto_previous_start = {},
              goto_previous_end = {},
            },
          },
        }
      end

      local moves = {
        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
      }

      local function has_textobjects_query(ft)
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return false
        end
        local okq, q = pcall(vim.treesitter.query.get, lang, 'textobjects')
        return okq and q ~= nil
      end

      local function make_desc(key, query)
        local desc = query:gsub('@', ''):gsub('%..*', '')
        desc = desc:sub(1, 1):upper() .. desc:sub(2)
        desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
        desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
        return desc
      end

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not has_textobjects_query(ft) then
          return
        end

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            if vim.wo[vim.fn.bufwinid(buf)].diff and key:find '[cC]' then
              goto continue
            end

            vim.keymap.set({ 'n', 'x', 'o' }, key, function()
              require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
            end, {
              buffer = buf,
              desc = make_desc(key, query),
              silent = true,
            })

            ::continue::
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('ts_textobjects_move', { clear = true }),
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
