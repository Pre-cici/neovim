local M = {}

local root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' }
local overseer = require('utils.overseer')

local function active_python()
  local ok, venv_selector = pcall(require, 'venv-selector')
  if ok then
    local python = venv_selector.python()
    if python and python ~= '' then
      return python
    end
  end

  local python = vim.fn.exepath('python3')
  if python ~= '' then
    return python
  end
  return 'python3'
end

local function current_file()
  return vim.api.nvim_buf_get_name(0)
end

local function is_test_name(name)
  return name and name:match('^test_')
end

local function nearest_pytest_target(bufnr)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)
  local stack = {}

  for linenr, line in ipairs(lines) do
    local indent, kind, name = line:match('^(%s*)(class)%s+([%w_]+)')
    if not kind then
      indent, kind, name = line:match('^(%s*)(def)%s+([%w_]+)')
    end

    if kind and name then
      local width = #indent
      while #stack > 0 and stack[#stack].indent >= width do
        table.remove(stack)
      end

      if kind == 'class' or is_test_name(name) then
        table.insert(stack, { indent = width, kind = kind, name = name, line = linenr })
      end
    end
  end

  local parts = {}
  for _, item in ipairs(stack) do
    if item.kind == 'class' or is_test_name(item.name) then
      table.insert(parts, item.name)
    end
  end

  if #parts == 0 then
    return nil
  end

  return table.concat(parts, '::')
end

function M.project_root(bufnr)
  bufnr = bufnr or 0
  local buf = vim.api.nvim_buf_get_name(bufnr)
  local start = (buf ~= '' and vim.fs.dirname(buf)) or vim.uv.cwd()
  local found = vim.fs.find(root_markers, { path = start, upward = true })[1]
  return found and vim.fs.dirname(found) or vim.uv.cwd()
end

function M.prepend_env(name, value)
  local sep = ':'
  local cur = vim.env[name] or ''
  if cur == '' then
    vim.env[name] = value
    return
  end
  for entry in string.gmatch(cur, '([^' .. sep .. ']+)') do
    if entry == value then
      return
    end
  end
  vim.env[name] = value .. sep .. cur
end

function M.ensure_pythonpath_autocmd()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('user_pythonpath_root', { clear = true }),
    pattern = '*.py',
    callback = function(event)
      M.prepend_env('PYTHONPATH', M.project_root(event.buf))
    end,
  })
end

function M.run_current_file_task()
  local file = current_file()
  if file == '' then
    return vim.notify('Save the current Python buffer first', vim.log.levels.WARN)
  end

  overseer.run({
    name = string.format('python %s', vim.fn.fnamemodify(file, ':t')),
    cmd = active_python(),
    args = { file },
    cwd = M.project_root(0),
    components = overseer.default_components(),
  })
end

-- function M.run_pytest_file_task()
--   local file = current_file()
--   if file == '' then
--     return vim.notify('Save the current Python buffer first', vim.log.levels.WARN)
--   end
--
--   overseer.run({
--     name = string.format('pytest %s', vim.fn.fnamemodify(file, ':t')),
--     cmd = active_python(),
--     args = { '-m', 'pytest', file, '-q' },
--     cwd = M.project_root(0),
--     components = overseer.default_components(),
--   })
-- end
--
-- function M.run_pytest_nearest_task()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local file = current_file()
--   if file == '' then
--     return vim.notify('Save the current Python buffer first', vim.log.levels.WARN)
--   end
--
--   local target = nearest_pytest_target(bufnr)
--   if not target then
--     return M.run_pytest_file_task()
--   end
--
--   local nodeid = string.format('%s::%s', file, target)
--   overseer.run({
--     name = string.format('pytest %s', target),
--     cmd = active_python(),
--     args = { '-m', 'pytest', nodeid, '-q' },
--     cwd = M.project_root(bufnr),
--     components = overseer.default_components(),
--   })
-- end

return M
