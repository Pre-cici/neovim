-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end


return {
  {
    "stevearc/oil.nvim",
    event = "VimEnter",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
      "benomahony/oil-git.nvim",
      {
        "JezerM/oil-lsp-diagnostics.nvim",
        opts = {
          count = false,
          parent_dirs = false,
        },
      },
    },
    cmd = "Oil",
    keys = {
      { "<leader>e", ":Oil<CR>" },
    },
    opts = {
      default_file_explorer = true,
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
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
    "mikavilpas/yazi.nvim",
    cmd = { "Yazi", "Yazi cwd", "Yazi toggle" },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 0.9,
    },
  },
}
