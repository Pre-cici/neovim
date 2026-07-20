return {
  {
    -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      format_on_save = false,
      formatters_by_ft = {
        lua = { "stylua" },

        python = {
          "ruff_fix", -- To fix auto-fixable lint errors.
          "ruff_organize_imports", -- To organize the imports.
          "ruff_format", -- To run the Ruff formatter.
        },

        markdown = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        jsonl = { "prettier" },

        bigfile = function(bufnr)
          local ft = vim.filetype.match({ buf = bufnr })
          if ft then
            return require("conform").formatters_by_ft[ft]
          end
        end,
      },
      formatters = {
        prettier = {
          options = {
            ft_parsers = {
              jsonl = "json",
            },
          },
        },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "lua-language-server",
        "ty",
        "ruff",
        "marksman",
        "clangd",
        "prettier",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" then
              vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
            end
          end
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
