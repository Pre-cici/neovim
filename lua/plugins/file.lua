return {
  {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-mini/mini.icons', opts = {} },
      'benomahony/oil-git.nvim',
      'JezerM/oil-lsp-diagnostics.nvim',
    },
    cmd = 'Oil',
    keys = {
      { '<leader>e', ':Oil<CR>' },
    },
    opts = {
      default_file_explorer = true,
      -- stylua: ignore
      keymaps = {
        ['<C-l>'] = 'actions.select',
        ['<C-h>'] = 'actions.parent',
        ['L'] = 'actions.select',
        ['H'] = 'actions.parent',
        ['<BS>'] = 'actions.parent',
        ['q'] = 'actions.close',
        ['<leader>e'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['<leader>y'] = 'actions.yank_entry',
        ["."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gp"] = "actions.preview",
        ["gc"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.tcd", mode = "n" }, -- different tab path
        ["~"] = { "actions.cd", mode = "n" },
        ['-'] = { 'actions.select', opts = { horizontal = true } },
        ['|'] = { 'actions.select', opts = { vertical = true } },
        ['gt'] = { 'actions.select', opts = { horizontal = true } },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },

      },
    },
  },

  {
    'mikavilpas/yazi.nvim',
    cmd = { 'Yazi', 'Yazi cwd', 'Yazi toggle' },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 0.9,
    },
  },


  --   {
  --   "zeioth/project.nvim",
  --   event = "VimEnter",
  --   cmd = "ProjectRoot",
  --   opts = {
  --     -- How to find root directory
  --     patterns = {
  --       ".git",
  --       "_darcs",
  --       ".hg",
  --       ".bzr",
  --       ".svn",
  --       "Makefile",
  --       "package.json",
  --       ".solution",
  --       ".solution.toml"
  --     },
  --     -- Don't list the next projects
  --     exclude_dirs = {
  --       "~/"
  --     },
  --     silent_chdir = true,
  --     manual_mode = false,
  --
  --     -- Don't chdir for certain buffers
  --     exclude_chdir = {
  --       filetype = {"", "OverseerList", "alpha"},
  --       buftype = {"nofile", "terminal"},
  --     },
  --
  --     --ignore_lsp = { "lua_ls" },
  --   },
  --   config = function(_, opts) require("project_nvim").setup(opts) end,
  -- },

}
