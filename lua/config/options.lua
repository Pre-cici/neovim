-- Leader (must be before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Globals
vim.g.inlay_hints = true
vim.g.transparent = true
vim.g.bordered = true
vim.g.autoformat = true
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }
vim.g.deprecation_warnings = false
vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- UI / display
opt.cmdheight = 0 -- Hide command line unless needed.
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
-- opt.statuscolumn = "%C%l %s"
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.laststatus = 3
opt.showmode = false
opt.ruler = false
opt.termguicolors = true
opt.list = true
opt.listchars = {
  trail = "·",
  tab = "».",     -- Tab 显示成 »·（你也可以用 "→ "）
  -- extends = "›",
  -- precedes = "‹",
  -- nbsp = "␣",
}
opt.winborder = vim.g.bordered and 'rounded' or 'none'

-- Mouse
opt.mouse = 'a'

-- Clipboard (disable in SSH)
opt.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus'

-- Indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true

-- Search / command
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'
opt.completeopt = 'menu,menuone,noselect'
opt.wildmode = 'longest:full,full'
opt.grepprg = 'rg --vimgrep'
opt.grepformat = '%f:%l:%c:%m'

-- Splits / windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.winminwidth = 5

-- Wrap / linebreak
opt.wrap = false
opt.linebreak = true
opt.showbreak = '↳ '

-- Timing
opt.updatetime = 200
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeout = true
opt.ttimeoutlen = 30

-- Files / undo
opt.autoread = true
opt.autowrite = true
opt.confirm = true
opt.undofile = true
opt.undolevels = 10000

-- Folding
opt.foldmethod = 'indent'
opt.foldlevel = 99
opt.foldtext = ''
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

-- Formatting behavior
opt.breakindent = true
opt.formatoptions = 'jcroqlnt'

-- Misc
opt.conceallevel = 2
opt.pumheight = 10
opt.pumblend = 10
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.jumpoptions = 'stack'
opt.smoothscroll = true
opt.spelllang = { 'en' }
opt.virtualedit = 'block'
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
