local keymap = vim.keymap
local diagnostic_utils = require("utils.diagnostic")
local root_utils = require("utils.root")
local terminal_utils = require("utils.terminal")

keymap.set("n", "<leader>fs", "<cmd>restart %<CR>", { desc = "Source current file" })

keymap.set("i", "jj", "<ESC>")
keymap.set("i", "jk", "<ESC>")

keymap.set("n", "q", "<nop>", { desc = "Disable macro recording" })
keymap.set("n", "Q", "q", { desc = "Record macro" })

-- number increment
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

-- better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", function() terminal_utils.navigate_window("Left") end, { desc = "Go to Left Window" })
keymap.set("n", "<C-j>", function() terminal_utils.navigate_window("Down") end, { desc = "Go to Lower Window" })
keymap.set("n", "<C-k>", function() terminal_utils.navigate_window("Up") end, { desc = "Go to Upper Window" })
keymap.set("n", "<C-l>", function() terminal_utils.navigate_window("Right") end, { desc = "Go to Right Window" })

keymap.set("t", "<C-h>", function() terminal_utils.navigate_from_terminal("Left") end, { desc = "Go to Left Window" })
keymap.set("t", "<C-j>", function() terminal_utils.navigate_from_terminal("Down") end, { desc = "Go to Lower Window" })
keymap.set("t", "<C-k>", function() terminal_utils.navigate_from_terminal("Up") end, { desc = "Go to Upper Window" })
keymap.set("t", "<C-l>", function() terminal_utils.navigate_from_terminal("Right") end, { desc = "Go to Right Window" })
keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

-- Move Lines
keymap.set("n", "<A-J>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-K>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap.set("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<A-J>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<A-K>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
keymap.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- refresh buffer
keymap.set("n", "<leader>r", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw Buffer" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- windows
keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- terminal
keymap.set({ "n", "t" }, "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })

-- tabs
keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- better indenting
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- quit
keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
keymap.set("i", ",", ",<c-g>u")
keymap.set("i", ".", ".<c-g>u")
keymap.set("i", ";", ";<c-g>u")

-- file
keymap.set("n", "<leader>fw", "<cmd>w<cr>", { desc = "Save File" })
keymap.set("n", "<leader>fn", function()
  local base = vim.fn.expand("%:p:h")
  if base == "" then
    base = vim.uv.cwd()
  end

  vim.ui.input({ prompt = "New file: ", default = base .. "/" }, function(path)
    if not path or path == "" then
      return
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
  end)
end, { desc = "New File" })

-- keywordprg
keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "LSP Hover" })

-- commenting
keymap.set("n", "gcO", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
keymap.set("n", "gco", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  keymap.set("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = root_utils.git_root(0) })
  end, { desc = "Lazygit (Root Dir)" })
  keymap.set("n", "<leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Lazygit (cwd)" })
end

-- TODO: location list / quickfix list / diagnostics
keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]d", diagnostic_utils.goto_factory(true), { desc = "Next Diagnostic" })
keymap.set("n", "[d", diagnostic_utils.goto_factory(false), { desc = "Prev Diagnostic" })
keymap.set("n", "]e", diagnostic_utils.goto_factory(true, "ERROR"), { desc = "Next Error" })
keymap.set("n", "[e", diagnostic_utils.goto_factory(false, "ERROR"), { desc = "Prev Error" })
keymap.set("n", "]w", diagnostic_utils.goto_factory(true, "WARN"), { desc = "Next Warning" })
keymap.set("n", "[w", diagnostic_utils.goto_factory(false, "WARN"), { desc = "Prev Warning" })
