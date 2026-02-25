-- after/ftplugin/python.lua

-- Visual: wrap selection with triple quotes (''' ... ''')
vim.keymap.set("v", "gca", function()
  -- Start/end of visual selection (linewise)
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Insert closing first (line numbers shift if you insert opening first)
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { "'''" })
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { "'''" })
end, { buffer = true, desc = "Wrap selection with ''' '''" })

-- after/ftplugin/python.lua

vim.keymap.set("v", "gcu", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Remove leading '# ' or '#'
  for l = start_line, end_line do
    local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1]
    line = line:gsub("^%s*#%s?", "")
    vim.api.nvim_buf_set_lines(0, l - 1, l, false, { line })
  end

  -- Wrap with triple quotes
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { "'''" })
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { "'''" })
end, { buffer = true, desc = "Convert # comments to ''' block" })

-- Run whole file with SnipRun, passing extra argv.

local function sniprun_file_with_argv()
  -- File completion: Tab completes paths
  local view = vim.fn.winsaveview()

  local args = vim.fn.input({
    prompt = "SnipRun argv: ",
    completion = "file",
  })

  if args ~= "" then
    vim.cmd("%SnipRun " .. args)
  else
    vim.cmd("%SnipRun")
  end

  vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>ca", sniprun_file_with_argv, {
  desc = "SnipRun: run whole file with argv (file completion)",
  silent = true,
})
