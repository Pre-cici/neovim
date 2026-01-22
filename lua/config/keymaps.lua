local keymap = vim.keymap

keymap.set('n', '<leader>fs', '<cmd>source %<CR>', { desc = 'Source current file' })

keymap.set('i', 'jj', '<ESC>')

keymap.set('n', 'q', '<nop>', { desc = 'Disable macro recording' })
keymap.set('n', 'Q', 'q', { desc = 'Record macro' })

-- better up/down
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })


-- Move to window using the <ctrl> hjkl keys
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Resize window using <ctrl> arrow keys
keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Move Lines
keymap.set('n', '<A-J>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
keymap.set('n', '<A-K>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
keymap.set('i', '<A-J>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
keymap.set('i', '<A-K>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
keymap.set('v', '<A-J>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
keymap.set('v', '<A-K>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- buffers
keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
keymap.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })


--keywordprg
keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- refresh buffer
keymap.set('n', '<leader>r', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw Buffer' })
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- windows
keymap.set('n', '<leader>w', '<C-w>', { desc = 'Window prefix' })
keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

-- tabs
keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })

-- better indenting
keymap.set('x', '<', '<gv')
keymap.set('x', '>', '>gv')

-- quit
keymap.set('n', '<leader>qa', '<cmd>qa<cr>', { desc = 'Quit All' })

keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Add undo break-points
keymap.set('i', ',', ',<c-g>u')
keymap.set('i', '.', '.<c-g>u')
keymap.set('i', ';', ';<c-g>u')

-- file
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
keymap.set('n', '<leader>fw', '<cmd>write ++p<cr>', { desc = 'Save (mkdir -p)' }) -- create parent dirs if needed :contentReference[oaicite:2]{index=2}
keymap.set('n', '<leader>fn', function()
  local base = vim.fn.expand '%:p:h'
  if base == '' then
    base = vim.uv.cwd()
  end

  vim.ui.input({ prompt = 'New file: ', default = base .. '/' }, function(path)
    if not path or path == '' then
      return
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
  end)
end, { desc = 'New File' })

-- select all
keymap.set('n', '<leader>fA', 'ggVG', { desc = 'Select All' })

-- keywordprg
keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })
keymap.set('n', 'K', function()
  vim.lsp.buf.hover { border = 'rounded' }
end, { desc = 'LSP Hover' })

-- commenting
keymap.set('n', 'gcO', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
keymap.set('n', 'gco', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- lazy
keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- TODO: utils/get_root
local function get_root(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local path = (name ~= '' and vim.fs.dirname(name)) or vim.uv.cwd()

  local git = vim.fs.find('.git', { path = path, upward = true })[1]
  if git then
    return vim.fs.dirname(git)
  end
  return vim.uv.cwd()
end

-- lazygit
if vim.fn.executable 'lazygit' == 1 then
  keymap.set('n', '<leader>gg', function()
    Snacks.lazygit { cwd = get_root(0) }
  end, { desc = 'Lazygit (Root Dir)' })
  keymap.set('n', '<leader>gG', function()
    Snacks.lazygit()
  end, { desc = 'Lazygit (cwd)' })
end

-- TODO: location list / quickfix list / diagnostics
keymap.set("n", "<leader>cl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

keymap.set("n", "<leader>cq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- TODO:  toggle options

-- toggle options
-- LazyVim.format.snacks_toggle():map("<leader>uf")
-- LazyVim.format.snacks_toggle(true):map("<leader>uF")
-- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
-- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
-- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
-- Snacks.toggle.diagnostics():map("<leader>ud")
-- Snacks.toggle.line_number():map("<leader>ul")
-- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
-- Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
-- Snacks.toggle.treesitter():map("<leader>uT")
-- Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
-- Snacks.toggle.dim():map("<leader>uD")
-- Snacks.toggle.animate():map("<leader>ua")
-- Snacks.toggle.indent():map("<leader>ug")
-- Snacks.toggle.scroll():map("<leader>uS")
-- Snacks.toggle.profiler():map("<leader>dpp")
-- Snacks.toggle.profiler_highlights():map("<leader>dph")
