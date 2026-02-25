-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  -- highlight-start
  spec = {
    -- import your plugins
    { import = 'plugins.editor' },
    { import = 'plugins.file' },
    { import = 'plugins.picker' },
    { import = 'plugins.ui' },
    { import = 'plugins.colorscheme' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.snacks' },
    { import = 'plugins.lspconfig' },
    { import = 'plugins.completion' },
    { import = 'plugins.statusline' },
    { import = 'plugins.code' },
    { import = 'plugins.debug' },
    { import = 'plugins.markdown' },
    { import = 'plugins.python' },
    { import = 'plugins.ai' },
    { import = 'plugins.leetcode' },
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false},
}
