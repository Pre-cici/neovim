return {
  {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    cmd = 'Oil',
    keys = {
      { '<leader>e', ':Oil<CR>' },
    },
    opts = {
      default_file_explorer = true,
      -- stylua: ignore
      keymaps = {
        ['L'] = 'actions.select',
        ['H'] = 'actions.parent',
        ['q'] = 'actions.close',
        ['<leader>e'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['<leader>y'] = 'actions.yank_entry',
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gp"] = "actions.preview",
        ["gc"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.tcd", mode = "n" }, -- different tab path
        ["~"] = { "actions.cd", mode = "n" },
        ['-'] = { 'actions.select', opts = { horizontal = true } },
        ['|'] = { 'actions.select', opts = { vertical = true } },
        ['gt'] = { 'actions.select', opts = { horizontal = true } },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gd"] = function() require("oil").set_columns({ "icon", "permissions", "size", "mtime" }) end,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
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
}
