return {
  {
    'linux-cultist/venv-selector.nvim',
    cmd = 'VenvSelect',
    opts = {
      options = {
        notify_user_on_venv_activation = true,
      },
    },
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' } },
    config = function(_, opts)
      local orig = vim.notify
      require('venv-selector').setup(opts)
      vim.notify = orig
    end,
  },
}
